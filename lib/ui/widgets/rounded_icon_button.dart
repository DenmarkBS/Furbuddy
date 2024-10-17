import 'package:flutter/material.dart';

class RoundedIconButton extends StatelessWidget {
  final Function onPressed;
  final IconData iconData;
  final double iconSize;
  final double paddingReduce;
  final Color? buttonColor;
  final Color? iconColor;

  const RoundedIconButton({
    Key? key,
    required this.onPressed,
    required this.iconData,
    this.iconSize = 10,
    required this.buttonColor,
    this.paddingReduce = 0,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minWidth: 0,
      elevation: 5,
      color: buttonColor ?? Colors.transparent,
      onPressed: () {
        onPressed.call();
      },
      padding: EdgeInsets.all((iconSize / 3) - paddingReduce),
      shape: const CircleBorder(),
      child: Icon(
        iconData,
        size: iconSize,
        color: iconColor ?? Theme.of(context).iconTheme.color,
      ),
    );
  }
}
