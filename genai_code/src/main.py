from typing import Dict

from fastapi import FastAPI, HTTPException, status
from pydantic import BaseModel, Field


app = FastAPI(
    title="Vehicle API",
    description="CRUD API for vehicles and manufacturers",
    version="1.0.0",
)

# Use this command to run the API: uv run uvicorn main:app --app-dir src --reload


# ---------------------------------------------------------------------------
# Models
# ---------------------------------------------------------------------------

class ManufacturerCreate(BaseModel):
    name: str = Field(min_length=1, max_length=100)
    country: str = Field(min_length=1, max_length=100)


class Manufacturer(ManufacturerCreate):
    id: int


class VehicleCreate(BaseModel):
    make: str = Field(min_length=1, max_length=100)
    model: str = Field(min_length=1, max_length=100)
    year: int = Field(ge=1886, le=2100)
    manufacturer_id: int


class Vehicle(VehicleCreate):
    id: int


# ---------------------------------------------------------------------------
# In-Memory Storage & Counters
# ---------------------------------------------------------------------------

manufacturers: Dict[int, dict] = {}
vehicles: Dict[int, dict] = {}

next_manufacturer_id = 1
next_vehicle_id = 1

# ---------------------------------------------------------------------------
# Endpoints
# ---------------------------------------------------------------------------

@app.post(
    "/manufacturers",
    response_model=Manufacturer,
    status_code=status.HTTP_201_CREATED,
)
def create_manufacturer(manufacturer: ManufacturerCreate):
    global next_manufacturer_id

    new_manufacturer = Manufacturer(
        id=next_manufacturer_id,
        **manufacturer.model_dump(),
    )

    manufacturers[next_manufacturer_id] = new_manufacturer
    next_manufacturer_id += 1

    return new_manufacturer


@app.get("/manufacturers", response_model=list[Manufacturer])
def list_manufacturers():
    return list(manufacturers.values())


@app.get("/manufacturers/{manufacturer_id}", response_model=Manufacturer)
def get_manufacturer(manufacturer_id: int):
    manufacturer = manufacturers.get(manufacturer_id)

    if manufacturer is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Manufacturer not found",
        )

    return manufacturer


@app.put("/manufacturers/{manufacturer_id}", response_model=Manufacturer)
def update_manufacturer(
    manufacturer_id: int,
    manufacturer: ManufacturerCreate,
):
    if manufacturer_id not in manufacturers:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Manufacturer not found",
        )

    updated_manufacturer = Manufacturer(
        id=manufacturer_id,
        **manufacturer.model_dump(),
    )

    manufacturers[manufacturer_id] = updated_manufacturer

    return updated_manufacturer


@app.delete(
    "/manufacturers/{manufacturer_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
def delete_manufacturer(manufacturer_id: int):
    if manufacturer_id not in manufacturers:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Manufacturer not found",
        )

    # Don't allow deletion while vehicles still reference it.
    has_vehicles = any(
        vehicle.manufacturer_id == manufacturer_id
        for vehicle in vehicles.values()
    )

    if has_vehicles:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Cannot delete manufacturer while vehicles reference it",
        )

    del manufacturers[manufacturer_id]


# ---------------------------------------------------------------------------
# Vehicle endpoints
# ---------------------------------------------------------------------------

@app.post(
    "/vehicles",
    response_model=Vehicle,
    status_code=status.HTTP_201_CREATED,
)
def create_vehicle(vehicle: VehicleCreate):
    global next_vehicle_id

    if vehicle.manufacturer_id not in manufacturers:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Manufacturer does not exist",
        )

    new_vehicle = Vehicle(
        id=next_vehicle_id,
        **vehicle.model_dump(),
    )

    vehicles[next_vehicle_id] = new_vehicle
    next_vehicle_id += 1

    return new_vehicle


@app.get("/vehicles", response_model=list[Vehicle])
def list_vehicles():
    return list(vehicles.values())


@app.get("/vehicles/{vehicle_id}", response_model=Vehicle)
def get_vehicle(vehicle_id: int):
    vehicle = vehicles.get(vehicle_id)

    if vehicle is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Vehicle not found",
        )

    return vehicle


@app.put("/vehicles/{vehicle_id}", response_model=Vehicle)
def update_vehicle(
    vehicle_id: int,
    vehicle: VehicleCreate,
):
    if vehicle_id not in vehicles:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Vehicle not found",
        )

    if vehicle.manufacturer_id not in manufacturers:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Manufacturer does not exist",
        )

    updated_vehicle = Vehicle(
        id=vehicle_id,
        **vehicle.model_dump(),
    )

    vehicles[vehicle_id] = updated_vehicle

    return updated_vehicle


@app.delete(
    "/vehicles/{vehicle_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
def delete_vehicle(vehicle_id: int):
    if vehicle_id not in vehicles:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Vehicle not found",
        )

    del vehicles[vehicle_id]