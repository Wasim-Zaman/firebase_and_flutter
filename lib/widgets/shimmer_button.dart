import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  const ShimmerButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.teal,
      highlightColor: Colors.tealAccent,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          child: Text(text),
        ),
      ),
    );
  }
}
