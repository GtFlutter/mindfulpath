import 'package:flutter/material.dart';

class CustomBottomNavItem extends StatefulWidget {
  final Widget icon;
  final Widget activeIcon;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  final double startPadding;
  final double endPadding;
  const CustomBottomNavItem(
      {super.key,
      required this.icon,
      required this.onTap,
      required this.index,
      required this.selectedIndex,
      required this.activeIcon,
      required this.startPadding,
      required this.endPadding});

  @override
  State<CustomBottomNavItem> createState() => _CustomBottomNavItemState();
}

class _CustomBottomNavItemState extends State<CustomBottomNavItem> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _topPadding;
  late Animation<double> _bottomPadding;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTap() {
    if (widget.index != widget.selectedIndex) {
      widget.onTap(widget.index);
    }
  }

  void _handlePress() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _topPadding = Tween<double>(begin: widget.startPadding, end: widget.endPadding).animate(_animationController);
    _bottomPadding = Tween<double>(begin: widget.endPadding, end: widget.startPadding).animate(_animationController);
    if (widget.index == widget.selectedIndex) {
      _handlePress();
    }
  }

  @override
  void didUpdateWidget(covariant CustomBottomNavItem oldWidget) {
    if ((widget.selectedIndex != oldWidget.selectedIndex && widget.index == widget.selectedIndex) ||
        (oldWidget.selectedIndex == oldWidget.index && widget.selectedIndex != widget.index)) {
      _handlePress();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Padding(
          padding: EdgeInsets.only(top: _topPadding.value, bottom: _bottomPadding.value),
          child: child,
        );
      },
      child: IconButton(
        icon: widget.icon,
        isSelected: widget.index == widget.selectedIndex,
        selectedIcon: widget.activeIcon,
        style: IconButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          splashFactory: InkSplash.splashFactory,
        ),
        onPressed: _onTap,
      ),
    );
  }
}
