part of 'animator.dart';

typedef Disposer = void Function();

class _StateBuilder<T extends Widget> extends StatefulWidget {
  final _Builder<T> Function(BuildContext context, T widget,
      TickerProvider ticker, bool Function() setState) initState;

  final bool isSingleTicker;
  final T widget;
  const _StateBuilder(
    this.initState, {
    Key? key,
    this.isSingleTicker = true,
    required this.widget,
  }) : super(key: key);

  @override
  __StateBuilderState<T> createState() {
    if (isSingleTicker) {
      return __StateBuilderSingleTickerState<T>();
    }
    return __StateBuilderTickerState<T>();
  }
}

class __StateBuilderSingleTickerState<T extends Widget>
    extends __StateBuilderState<T> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _builder = widget.initState(
      context,
      widget.widget,
      this,
      () {
        if (mounted) {
          setState(() {});
        }
        return false;
      },
    );
  }

  void dispose() {
    _builder.dispose();
    super.dispose();
  }
}

class __StateBuilderTickerState<T extends Widget> extends __StateBuilderState<T>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _builder = widget.initState(
      context,
      widget.widget,
      this,
      () {
        if (mounted) {
          setState(() {});
        }
        return false;
      },
    );
  }

  void dispose() {
    _builder.dispose();
    super.dispose();
  }
}

class __StateBuilderState<T extends Widget> extends State<_StateBuilder<T>> {
  late _Builder<T> _builder;

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _builder.didUpdateWidget.call(oldWidget.widget, widget.widget);
  }

  @override
  Widget build(BuildContext context) {
    return _builder.builder(context, widget.widget);
  }
}

class _Builder<T> {
  final void Function() dispose;
  final void Function(T oldWidget, T newWidget) didUpdateWidget;
  final Widget Function(BuildContext context, T widget) builder;

  _Builder({
    required this.builder,
    required this.dispose,
    required this.didUpdateWidget,
  });
}
