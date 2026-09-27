import 'package:flutter/material.dart';

/// Flutter code sample for [WidgetsBindingObserver].

void main() => runApp(const WidgetBindingObserverExampleApp());

class WidgetBindingObserverExampleApp extends StatelessWidget {
  const WidgetBindingObserverExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('WidgetBindingsObserver Sample')),
        body: const WidgetBindingsObserverSample(),
      ),
    );
  }
}

class WidgetBindingsObserverSample extends StatefulWidget {
  const WidgetBindingsObserverSample({super.key});

  @override
  State<WidgetBindingsObserverSample> createState() =>
      _WidgetBindingsObserverSampleState();
}

class _WidgetBindingsObserverSampleState
    extends State<WidgetBindingsObserverSample>
    with WidgetsBindingObserver {
  final List<String> _stringHistoryList = <String>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (WidgetsBinding.instance.lifecycleState != null) {
      _stringHistoryList.add("Initial resumed");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint('Print State: App resumed');
    } else if (state == AppLifecycleState.paused) {
      debugPrint('Print State: App paused');
    } else if (state == AppLifecycleState.detached) {
      debugPrint('Print State: App detached');
    } else if (state == AppLifecycleState.inactive) {
      debugPrint('Print State: App inactive');
    }

    setState(() {
      String text = "";
      if (state == AppLifecycleState.resumed) {
        text = 'Print State: App resumed';
        debugPrint(text);
        _stringHistoryList.add(text);
      } else if (state == AppLifecycleState.paused) {
        text = 'Print State: App paused';
        debugPrint(text);
        _stringHistoryList.add(text);
      } else if (state == AppLifecycleState.detached) {
        text = 'Print State: App detached';
        debugPrint(text);
        _stringHistoryList.add(text);
      } else if (state == AppLifecycleState.inactive) {
        text = 'Print State: App inactive';
        debugPrint(text);
        _stringHistoryList.add(text);
      } else if (state == AppLifecycleState.hidden) {
        text = 'Print State: App hidden';
        debugPrint(text);
        _stringHistoryList.add(text);
      } else {
        text = state.toString();
        debugPrint(text);
        _stringHistoryList.add(text);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_stringHistoryList.isNotEmpty) {
      return ListView.builder(
        key: const ValueKey<String>('stringHistoryList'),
        itemCount: _stringHistoryList.length,
        itemBuilder: (BuildContext context, int index) {
          return Text('${_stringHistoryList[index]}');
        },
      );
    }

    return const Center(
      child: Text('There are no AppLifecycleStates to show.'),
    );
  }
}
