import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonContainer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry margin;

  const SkeletonContainer._({
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    this.margin = const EdgeInsets.all(0),
    Key? key,
  }) : super(key: key);

  const SkeletonContainer.square({
    required double width,
    required double height,
  }) : this._(width: width, height: height);

  const SkeletonContainer.rounded({
    required double width,
    required double height,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(10)),
    EdgeInsetsGeometry margin = const EdgeInsets.all(0),
  }) : this._(width: width, height: height, borderRadius: borderRadius, margin: margin);

  const SkeletonContainer.card({
    required double width,
    required double height,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(12)),
    EdgeInsetsGeometry margin = const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
  }) : this._(width: width, height: height, borderRadius: borderRadius, margin: margin);

  const SkeletonContainer.circular({
    required double width,
    required double height,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(80)),
    EdgeInsetsGeometry margin = const EdgeInsets.all(0),
  }) : this._(width: width, height: height, borderRadius: borderRadius, margin: margin);


  @override
  Widget build(BuildContext context) => SkeletonAnimation(
    //gradientColor: Colors.orange,
    //shimmerColor: Colors.red,
    //curve: Curves.easeInQuad,
    child: Padding(
      padding: margin,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: borderRadius,
        ),
      ),
    ),
  );
}