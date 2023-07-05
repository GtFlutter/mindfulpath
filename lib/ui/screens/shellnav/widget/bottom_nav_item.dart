import 'package:flutter/material.dart';

class BottomNavItem extends StatefulWidget {
  final Widget icon;
  const BottomNavItem({super.key, required this.icon});

  @override
  State<BottomNavItem> createState() => _BottomNavItemState();
}

class _BottomNavItemState extends State<BottomNavItem> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _topPadding;
  late Animation<double> _bottomPadding;

  final double _startPadding = 16.0;
  final double _endPadding = 8.0;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

    _topPadding = Tween<double>(begin: _startPadding, end: _endPadding).animate(_animationController);
    _bottomPadding = Tween<double>(begin: _endPadding, end: _startPadding).animate(_animationController);
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
        padding: EdgeInsets.zero,
        splashRadius: 50,
        onPressed: _handlePress,
      ),
    );
  }
}
