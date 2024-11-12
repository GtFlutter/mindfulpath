import 'dart:async' show Timer;

import 'package:flutter/material.dart';

import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';

class Greeting extends StatefulWidget {
  const Greeting({super.key, required this.style});

  final AppStyle style;

  @override
  State<Greeting> createState() => _GreetingState();
}

class _GreetingState extends State<Greeting> {
  late Timer _timer;
  late String _greeting;
  @override
  void initState() {
    super.initState();
    _setGreeting(notifie: false);
    Future.delayed(Duration.zero, _startTimer);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 5), (_) => _setGreeting());
  }

  void _setGreeting({bool notifie = true}) {
    _greeting = _generateGreeting();
    if (notifie) setState(() {});
  }

  String _generateGreeting() {
    var hour = DateTime.now().hour;
    return hour < 12
        ? 'Good Morning'
        : hour < 17
            ? 'Good Afternoon'
            : 'Good Evening';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _greeting,
      style: widget.style.text.font(mulishLight300, sizePx: 20, color: Colors.white),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
