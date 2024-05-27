import 'package:flutter/material.dart';

class CustomTabView extends StatefulWidget {
  final int itemCount;
  final int initPosition;
  final bool isScrollable;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final ValueChanged<int>? onPositionChange;
  final ValueChanged<double>? onScroll;

  const CustomTabView({
    super.key,
    required this.itemCount,
    required this.tabBuilder,
    required this.pageBuilder,
    this.initPosition = 0,
    this.isScrollable = true,
    this.onPositionChange,
    this.onScroll,
  });

  @override
  CustomTabsState createState() => CustomTabsState();
}

class CustomTabsState extends State<CustomTabView> with TickerProviderStateMixin {
  GlobalKey _key = GlobalKey();
  late TabController controller;
  late int currentPosition;

  @override
  void initState() {
    currentPosition = widget.initPosition;
    initializeTabController();
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    _key = GlobalKey();
    if (controller.length != widget.itemCount) {
      currentPosition = widget.initPosition;
      disposeTabController();
      initializeTabController();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    return Column(
      children: [
        Align(
          alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
          child: TabBar(
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelStyle: Theme.of(context).textTheme.titleMedium,
            labelColor: Theme.of(context).colorScheme.primary,
            labelPadding: EdgeInsets.zero,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurface,

            // indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
            // labelStyle: Theme.of(context).tabBarTheme.labelStyle,
            // labelColor: Theme.of(context).tabBarTheme.labelColor,
            // labelPadding: Theme.of(context).tabBarTheme.labelPadding,

            // unselectedLabelColor:
            //     Theme.of(context).tabBarTheme.unselectedLabelColor,
            unselectedLabelStyle: Theme.of(context).tabBarTheme.unselectedLabelStyle,

            indicator: Theme.of(context).tabBarTheme.indicator,
            indicatorSize: Theme.of(context).tabBarTheme.indicatorSize,

            overlayColor: Theme.of(context).tabBarTheme.overlayColor,
            splashFactory: Theme.of(context).tabBarTheme.splashFactory,

            dividerColor: Theme.of(context).tabBarTheme.dividerColor,

            isScrollable: widget.isScrollable,
            controller: controller,
            tabs: List.generate(
              widget.itemCount,
              (index) => Builder(
                builder: (context) => widget.tabBuilder(context, index),
              ),
            ),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: TabBarView(
            key: _key,
            controller: controller,
            children: List.generate(
              widget.itemCount,
              (index) => Builder(builder: (context) => widget.pageBuilder(context, index)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    disposeTabController();
    super.dispose();
  }

  void initializeTabController() {
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: currentPosition,
    );
    controller.addListener(_onPositionChange);
    controller.animation?.addListener(_onScroll);
  }

  void disposeTabController() {
    controller.animation?.removeListener(_onScroll);
    controller.removeListener(_onPositionChange);
    controller.dispose();
  }

  _onPositionChange() {
    if (!controller.indexIsChanging) {
      currentPosition = controller.index;
      widget.onPositionChange?.call(currentPosition);
    }
  }

  _onScroll() {
    widget.onScroll?.call(controller.animation!.value);
  }
}
