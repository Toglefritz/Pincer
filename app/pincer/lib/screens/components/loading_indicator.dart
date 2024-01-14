import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// Displays an animation and message while loading processes are underway.
///
/// The loading indicator consists of two components: an animation depicting the gripper of a Pincer robot arm
/// opening and closing with a message below the animation communicating the current loading operation.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key, required this.message,
  });

  /// The message to display below the loading animation.
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 200,
          height: 161.5,
          child: RiveAnimation.asset(
            'assets/pincer_loading_indicator.riv',
          ),
        ),
        Text(
          message,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}