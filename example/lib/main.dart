import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_loading_buttons/material_loading_buttons.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material loading buttons',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
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
    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedAutoLoadingButton(
                  onPressed: _onPressed,
                  child: const Text('ElevatedLoadingButton'),
                ),
                const SizedBox(height: 16),
                FilledAutoLoadingButton(
                  onPressed: _onPressed,
                  loadingLabel: const Text('loading...'),
                  child: const Text('FilledLoadingButton'),
                ),
                const SizedBox(height: 16),
                FilledAutoLoadingButton.tonal(
                  onPressed: _onPressed,
                  loadingIcon: const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.red),
                  ),
                  child: const Text('ElevatedLoadingButton tonal'),
                ),
                const SizedBox(height: 16),
                OutlinedAutoLoadingButton(
                  onPressed: _onPressed,
                  loadingIcon: const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.green),
                  ),
                  loadingLabel: const Text('loading...'),
                  child: const Text('OutlinedLoadingButton'),
                ),
                const SizedBox(height: 16),
                TextAutoLoadingButton(
                  onPressed: _onPressed,
                  child: const Text('TextLoadingButton'),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedAutoLoadingButton.icon(
                  onPressed: _onPressed,
                  icon: const Icon(Icons.add),
                  label: const Text('ElevatedLoadingButton Icon'),
                ),
                const SizedBox(height: 16),
                FilledAutoLoadingButton.icon(
                  onPressed: _onPressed,
                  loadingLabel: const Text('loading...'),
                  icon: const Icon(Icons.add),
                  label: const Text('FilledLoadingButton Icon'),
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                const ManualOutlinedLoadingButton(),
                const SizedBox(height: 16),
                const BackgroundTextAutoLoadingButton(),
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
              const Duration(milliseconds: 50), (count) => count * 50 / 3000)
          .takeWhileInclusive((e) => e <= 1)
          .doOnDone(() {
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
    return OutlinedLoadingButton.icon(
      isLoading: _isLoading,
      loadingIcon: SizedBox(
        width: 24,
        height: 24,
        child: StreamBuilder<double>(
          initialData: 0,
          stream: _progress,
          builder: (context, snapshot) => CircularProgressIndicator(
            value: snapshot.data,
            color: color,
          ),
        ),
      ),
      onPressed: _onPressed,
      icon: const Icon(Icons.add),
      label: const Text('OutlinedLoadingButton'),
    );
  }
}

/// 通过api在后台主动发起点击事件加载操作的按钮实例
class BackgroundTextAutoLoadingButton extends StatefulWidget {
  const BackgroundTextAutoLoadingButton({super.key});

  @override
  State createState() => _BackgroundTextAutoLoadingButtonState();
}

class _BackgroundTextAutoLoadingButtonState
    extends State<BackgroundTextAutoLoadingButton> {
  /// 控制各种AutoLoadingButton的key
  final _loadingKey = GlobalKey<AutoLoadingButtonState>();

  /// 模拟主动触发加载的定时器
  late Timer _timer;

  Future<void> _onPressed() async {
    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _loadingKey.currentState!.doPress();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextAutoLoadingButton.icon(
      key: _loadingKey,
      onPressed: _onPressed,
      icon: const Icon(Icons.add),
      label: const Text('TextLoadingButton Icon'),
    );
  }
}
