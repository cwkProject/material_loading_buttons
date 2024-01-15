// Created by 超悟空 on 2023/2/6.

part of material_loading_buttons;

/// 带有自动管理加载状态表示的[FilledButton]实现
///
/// 按钮事件触发后将会自动进入加载状态，显示加载中图标和加载提示文本，且不响应点击事件，
/// 如果[loadingIcon]为空则会使用默认的[CircularProgressIndicator]。
/// 如果[loadingLabel]为空则不显示提示文本，
/// 同时事件返回一个[Future]，完成时表示加载结束，并自动回到非加载状态（可参考[RefreshIndicator]的模式）。
///
/// 由于逻辑冲突原因，在自动管理按钮中不能使用[FilledLoadingButton.loadingPressable]参数，
/// 如有需要请自行使用[FilledLoadingButton]。
///
/// [switchDuration]为状态变化时导致的控件大小变化而执行的过渡动画时间，内部使用[AnimatedSize]实现，默认为[kThemeAnimationDuration]。
///
/// [style]请参考使用[FilledButton.styleFrom]生成
class FilledAutoLoadingButton extends StatefulWidget {
  const FilledAutoLoadingButton({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.statesController,
    this.loadingIcon,
    this.loadingLabel,
    this.switchDuration = kThemeAnimationDuration,
    required this.child,
  }) : _tonal = false;

  /// 带有前导图标的变种
  FilledAutoLoadingButton.icon({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    this.statesController,
    this.loadingIcon,
    this.loadingLabel,
    Duration? switchDuration,
    required Widget icon,
    required Widget label,
  })  : autofocus = autofocus ?? false,
        clipBehavior = clipBehavior ?? Clip.none,
        switchDuration = switchDuration ?? kThemeAnimationDuration,
        child = _ButtonWithIconChild(label: label, icon: icon),
        _tonal = false;

  const FilledAutoLoadingButton.tonal({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.statesController,
    this.loadingIcon,
    this.loadingLabel,
    this.switchDuration = kThemeAnimationDuration,
    required this.child,
  }) : _tonal = true;

  /// 带有前导图标的变种
  FilledAutoLoadingButton.tonalIcon({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    this.statesController,
    this.loadingIcon,
    this.loadingLabel,
    Duration? switchDuration,
    required Widget icon,
    required Widget label,
  })  : autofocus = autofocus ?? false,
        clipBehavior = clipBehavior ?? Clip.none,
        switchDuration = switchDuration ?? kThemeAnimationDuration,
        child = _ButtonWithIconChild(label: label, icon: icon),
        _tonal = true;

  /// 按钮点击事件
  ///
  /// 当点击触发时按钮会自动进入加载状态不再接收新事件，
  /// 直到本次事件返回完成后才能结束加载状态
  ///
  /// 如果此值和[onLongPress]都为null则按钮处于禁用状态
  final AsyncCallback? onPressed;

  /// 按钮长按事件
  ///
  /// 当长按触发时按钮会自动进入加载状态不再接收新事件，
  /// 直到本次事件返回完成后才能结束加载状态
  ///
  /// 如果此值和[onPressed]都为null则按钮处于禁用状态
  final AsyncCallback? onLongPress;

  /// Called when a pointer enters or exits the button response area.
  ///
  /// The value passed to the callback is true if a pointer has entered this
  /// part of the material and false if a pointer has exited this part of the
  /// material.
  final ValueChanged<bool>? onHover;

  /// Handler called when the focus changes.
  ///
  /// Called with true if this widget's node gains focus, and false if it loses
  /// focus.
  final ValueChanged<bool>? onFocusChange;

  /// Customizes this button's appearance.
  ///
  /// Non-null properties of this style override the corresponding
  /// properties in [themeStyleOf] and [defaultStyleOf]. [MaterialStateProperty]s
  /// that resolve to non-null values will similarly override the corresponding
  /// [MaterialStateProperty]s in [themeStyleOf] and [defaultStyleOf].
  ///
  /// Null by default.
  final ButtonStyle? style;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.none], and must not be null.
  final Clip clipBehavior;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@macro flutter.material.inkwell.statesController}
  final MaterialStatesController? statesController;

  /// Typically the button's label.
  final Widget? child;

  /// 当处于加载状态时显示的加载图标
  ///
  /// 默认实现为[_LoadingChild]
  final Widget? loadingIcon;

  /// 当处于加载状态时显示的提示文本
  ///
  /// 默认为空
  final Widget? loadingLabel;

  /// 状态变化时导致的控件大小变化而执行的过渡动画时间
  ///
  /// 内部使用[AnimatedSize]实现，默认为[kThemeAnimationDuration]
  final Duration switchDuration;

  /// 是否为tonal变体
  final bool _tonal;

  @override
  State createState() => _FilledAutoLoadingButtonState();
}

class _FilledAutoLoadingButtonState
    extends AutoLoadingButtonState<FilledAutoLoadingButton> {
  @override
  AsyncCallback? get _onPressed => widget.onPressed;

  @override
  AsyncCallback? get _onLongPress => widget.onLongPress;

  @override
  Widget build(BuildContext context) {
    if (widget._tonal) {
      return FilledLoadingButton.tonal(
        isLoading: _isLoading,
        onPressed: _wrapOnPressed(),
        onLongPress: _wrapOnLongPress(),
        onHover: widget.onHover,
        onFocusChange: widget.onFocusChange,
        style: widget.style,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        clipBehavior: widget.clipBehavior,
        statesController: widget.statesController,
        loadingIcon: widget.loadingIcon,
        loadingLabel: widget.loadingLabel,
        loadingPressable: false,
        switchDuration: widget.switchDuration,
        child: widget.child,
      );
    }

    return FilledLoadingButton(
      isLoading: _isLoading,
      onPressed: _wrapOnPressed(),
      onLongPress: _wrapOnLongPress(),
      onHover: widget.onHover,
      onFocusChange: widget.onFocusChange,
      style: widget.style,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      clipBehavior: widget.clipBehavior,
      statesController: widget.statesController,
      loadingIcon: widget.loadingIcon,
      loadingLabel: widget.loadingLabel,
      loadingPressable: false,
      switchDuration: widget.switchDuration,
      child: widget.child,
    );
  }
}

/// 带有加载状态表示的[FilledButton]实现
///
/// [isLoading]表示当前是否处于正在加载状态，如果值为true则将会显示加载中图标和加载提示文本，响应点击事件受[loadingPressable]影响。
/// 如果[loadingIcon]为空则会使用默认的[CircularProgressIndicator]。
/// 如果[loadingLabel]为空则不显示提示。
///
/// 如果[isLoading]值为false则为非加载状态，仅显示[child]，且可响应点击事件。
///
/// [loadingPressable]表示在[isLoading]状态时是否可以响应点击事件，包括[onPressed]和[onLongPress]，默认为false。
/// [switchDuration]为状态变化时导致的控件大小变化而执行的过渡动画时间，内部使用[AnimatedSize]实现，默认为[kThemeAnimationDuration]。
///
/// [style]请参考使用[FilledButton.styleFrom]生成
class FilledLoadingButton extends FilledButton {
  FilledLoadingButton({
    super.key,
    required bool isLoading,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
    super.statesController,
    Widget? loadingIcon,
    Widget? loadingLabel,
    bool loadingPressable = false,
    Duration switchDuration = kThemeAnimationDuration,
    required Widget? child,
  }) : super(
          onPressed: isLoading && !loadingPressable ? null : onPressed,
          onLongPress: isLoading && !loadingPressable ? null : onLongPress,
          child: AnimatedSize(
            duration: switchDuration,
            child: !isLoading
                ? child
                : loadingLabel == null
                    ? loadingIcon ?? const _LoadingChild()
                    : _ButtonWithIconChild(
                        icon: loadingIcon ?? const _LoadingChild(),
                        label: loadingLabel,
                      ),
          ),
        );

  /// 参考[FilledButton.icon]
  FilledLoadingButton.icon({
    super.key,
    required bool isLoading,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    super.statesController,
    Widget? loadingIcon,
    Widget? loadingLabel,
    bool loadingPressable = false,
    Duration switchDuration = kThemeAnimationDuration,
    required Widget icon,
    required Widget label,
  }) : super(
          autofocus: autofocus ?? false,
          clipBehavior: clipBehavior ?? Clip.none,
          onPressed: isLoading && !loadingPressable ? null : onPressed,
          onLongPress: isLoading && !loadingPressable ? null : onLongPress,
          child: AnimatedSize(
            duration: switchDuration,
            child: !isLoading
                ? _ButtonWithIconChild(icon: icon, label: label)
                : loadingLabel == null
                    ? loadingIcon ?? const _LoadingChild()
                    : _ButtonWithIconChild(
                        icon: loadingIcon ?? const _LoadingChild(),
                        label: loadingLabel,
                      ),
          ),
        );

  /// 参考[FilledButton.tonal]
  FilledLoadingButton.tonal({
    super.key,
    required bool isLoading,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior = Clip.none,
    super.statesController,
    Widget? loadingIcon,
    Widget? loadingLabel,
    bool loadingPressable = false,
    Duration switchDuration = kThemeAnimationDuration,
    required Widget? child,
  }) : super.tonal(
          onPressed: isLoading && !loadingPressable ? null : onPressed,
          onLongPress: isLoading && !loadingPressable ? null : onLongPress,
          child: AnimatedSize(
            duration: switchDuration,
            child: !isLoading
                ? child
                : loadingLabel == null
                    ? loadingIcon ?? const _LoadingChild()
                    : _ButtonWithIconChild(
                        icon: loadingIcon ?? const _LoadingChild(),
                        label: loadingLabel,
                      ),
          ),
        );

  /// 参考[FilledButton.tonalIcon]
  FilledLoadingButton.tonalIcon({
    super.key,
    required bool isLoading,
    required VoidCallback? onPressed,
    VoidCallback? onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    super.statesController,
    Widget? loadingIcon,
    Widget? loadingLabel,
    bool loadingPressable = false,
    Duration switchDuration = kThemeAnimationDuration,
    required Widget icon,
    required Widget label,
  }) : super.tonal(
          autofocus: autofocus ?? false,
          clipBehavior: clipBehavior ?? Clip.none,
          onPressed: isLoading && !loadingPressable ? null : onPressed,
          onLongPress: isLoading && !loadingPressable ? null : onLongPress,
          child: AnimatedSize(
            duration: switchDuration,
            child: !isLoading
                ? _ButtonWithIconChild(icon: icon, label: label)
                : loadingLabel == null
                    ? loadingIcon ?? const _LoadingChild()
                    : _ButtonWithIconChild(
                        icon: loadingIcon ?? const _LoadingChild(),
                        label: loadingLabel,
                      ),
          ),
        );

  @override
  ButtonStyle defaultStyleOf(BuildContext context) {
    if ((child as AnimatedSize).child is! _ButtonWithIconChild) {
      return super.defaultStyleOf(context);
    }

    final bool useMaterial3 = Theme.of(context).useMaterial3;
    final EdgeInsetsGeometry scaledPadding = useMaterial3
        ? ButtonStyleButton.scaledPadding(
            const EdgeInsetsDirectional.fromSTEB(16, 0, 24, 0),
            const EdgeInsetsDirectional.fromSTEB(8, 0, 12, 0),
            const EdgeInsetsDirectional.fromSTEB(4, 0, 6, 0),
            MediaQuery.textScalerOf(context).textScaleFactor,
          )
        : ButtonStyleButton.scaledPadding(
            const EdgeInsetsDirectional.fromSTEB(12, 0, 16, 0),
            const EdgeInsets.symmetric(horizontal: 8),
            const EdgeInsetsDirectional.fromSTEB(8, 0, 4, 0),
            MediaQuery.textScalerOf(context).textScaleFactor,
          );
    return super.defaultStyleOf(context).copyWith(
          padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(scaledPadding),
        );
  }
}
