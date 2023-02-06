import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_loading_buttons/material_loading_buttons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material loading buttons',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Material loading buttons'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _onPressed() async {
    await Future.delayed(const Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedAutoLoadingButton(
                  onPressed: _onPressed,
                  child: const Text('ElevatedLoadingButton'),
                ),
                FilledAutoLoadingButton(
                  onPressed: _onPressed,
                  loadingLabel: const Text('loading...'),
                  child: const Text('FilledLoadingButton'),
                ),
                FilledAutoLoadingButton.tonal(
                  onPressed: _onPressed,
                  loadingIcon: const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.red),
                  ),
                  loadingLabel: const Text('loading...'),
                  child: const Text('ElevatedLoadingButton tonal'),
                ),
                const ManualOutlinedLoadingButton(),
                TextAutoLoadingButton(
                  onPressed: _onPressed,
                  child: const Text('TextLoadingButton'),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedAutoLoadingButton.icon(
                  onPressed: _onPressed,
                  icon: const Icon(Icons.add),
                  label: const Text('ElevatedLoadingButton Icon'),
                ),
                FilledAutoLoadingButton.icon(
                  onPressed: _onPressed,
                  loadingLabel: const Text('loading...'),
                  icon: const Icon(Icons.add),
                  label: const Text('FilledLoadingButton Icon'),
                ),
                FilledAutoLoadingButton.tonalIcon(
                  onPressed: _onPressed,
                  loadingIcon: const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.red),
                  ),
                  loadingLabel: const Text('loading...'),
                  icon: const Icon(Icons.add),
                  label: const Text('FilledLoadingButton tonal Icon'),
                ),
                OutlinedAutoLoadingButton.icon(
                  onPressed: _onPressed,
                  icon: const Icon(Icons.add),
                  label: const Text('OutlinedLoadingButton Icon'),
                ),
                TextAutoLoadingButton.icon(
                  onPressed: _onPressed,
                  icon: const Icon(Icons.add),
                  label: const Text('TextLoadingButton Icon'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 手动控制loading状态
class ManualOutlinedLoadingButton extends StatefulWidget {
  const ManualOutlinedLoadingButton({super.key});

  @override
  State createState() => _ManualOutlinedLoadingButtonState();
}

class _ManualOutlinedLoadingButtonState
    extends State<ManualOutlinedLoadingButton> {
  Stream<double>? _progress;

  bool _isLoading = false;

  void _onPressed() {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
      // 模拟5秒的可指示进度的耗时操作
      _progress = Stream.periodic(
              const Duration(milliseconds: 50), (count) => count * 50 / 5000)
          .timeout(const Duration(seconds: 5), onTimeout: (_) {
        setState(() {
          _isLoading = false;
          _progress = null;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return OutlinedLoadingButton(
      isLoading: _isLoading,
      loadingIcon: StreamBuilder<double>(
        initialData: 0,
        stream: _progress,
        builder: (context, snapshot) => CircularProgressIndicator(
          value: snapshot.data,
          color: color,
        ),
      ),
      onPressed: _onPressed,
      child: const Text('OutlinedLoadingButton'),
    );
  }
}
