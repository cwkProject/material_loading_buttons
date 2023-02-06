// Created by 超悟空 on 2023/2/6.

part of material_loading_buttons;

/// [ElevatedAutoLoadingButton]，[FilledAutoLoadingButton]的[State]父类
///
/// 提供标准实现
abstract class AutoLoadingButtonState<T extends StatefulWidget>
    extends State<T> {
  /// 主动触发执行widget的onPressed事件并进入加载状态
  ///
  /// 通过传递[GlobalKey]调用
  ///
  /// 返回原始onPressed事件完成的未来。
  /// 如果widget没有传递原始onPressed事件，则什么都不会发生，
  /// 如果widget正处于加载状态，则会返回当前执行的加载事件的未来，不会重复触发
  Future<void> doPress() {
    if (_onPressedFuture != null) {
      return _onPressedFuture!;
    }

    final onPressed = _onPressed;

    if (onPressed == null) {
      return Future.value();
    }

    final completer = Completer<void>();

    setState(() {
      _onPressedFuture = completer.future;
    });

    onPressed().then((value) {
      _onPressedFuture = null;
      completer.complete();

      if (mounted) {
        setState(() {});
      }
    });

    return completer.future;
  }

  /// 主动触发执行widget的onLongPress事件
  ///
  /// 通过传递[GlobalKey]调用
  ///
  /// 返回原始onLongPress事件完成的未来。
  /// 如果widget没有传递原始onLongPress事件，则什么都不会发生，
  /// 如果widget正处于加载状态，则会返回当前执行的加载事件的未来，不会重复触发
  Future<void> doLongPress() {
    if (_onLongPressFuture != null) {
      return _onLongPressFuture!;
    }

    final onPressed = _onLongPress;

    if (onPressed == null) {
      return Future.value();
    }

    final completer = Completer<void>();

    setState(() {
      _onLongPressFuture = completer.future;
    });

    onPressed().then((value) {
      _onLongPressFuture = null;
      completer.complete();

      if (mounted) {
        setState(() {});
      }
    });

    return completer.future;
  }

  /// 当前是否正在加载状态
  bool get _isLoading => _onPressedFuture != null || _onLongPressFuture != null;

  /// 如果当前正在执行onPressed加载事件则为它的完成未来，否则为空
  Future<void>? _onPressedFuture;

  /// 如果当前正在执行onLongPress加载事件则为它的完成未来，否则为空
  Future<void>? _onLongPressFuture;

  /// 原始widget点击事件
  AsyncCallback? get _onPressed;

  /// 原始widget长按事件
  AsyncCallback? get _onLongPress;

  /// [_onPressed]事件包装器
  VoidCallback? _wrapOnPressed() {
    return _onPressed == null ? null : doPress;
  }

  /// [_onLongPress]事件包装器
  VoidCallback? _wrapOnLongPress() {
    return _onLongPress == null ? null : doLongPress;
  }
}

class _ButtonWithIconChild extends StatelessWidget {
  const _ButtonWithIconChild(
      {Key? key, required this.label, required this.icon})
      : super(key: key);

  final Widget label;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final double scale = MediaQuery.maybeOf(context)?.textScaleFactor ?? 1;
    final double gap = scale <= 1 ? 8 : lerpDouble(8, 4, min(scale - 1, 1))!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[icon, SizedBox(width: gap), Flexible(child: label)],
    );
  }
}

class _LoadingChild extends StatelessWidget {
  const _LoadingChild({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    Widget result = CircularProgressIndicator(
      strokeWidth: 2,
      color: iconTheme.color,
    );

    result = Padding(
      padding: const EdgeInsets.all(2),
      child: result,
    );

    result = SizedBox.square(
      dimension: iconTheme.size ?? 24,
      child: result,
    );

    return result;
  }
}
