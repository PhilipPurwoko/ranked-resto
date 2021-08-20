import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

final Color _base = Colors.grey.shade300;
final Color _highlight = Colors.grey.shade100;

Shimmer toShimmer(Widget widget) => Shimmer.fromColors(
      baseColor: _base,
      highlightColor: _highlight,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: widget,
      ),
    );

Shimmer textShimmer = toShimmer(
  Container(
    width: double.infinity,
    height: 18.0,
    color: _base,
  ),
);

Shimmer imageShimmer = toShimmer(
  Container(
    width: double.infinity,
    height: 80,
    color: _base,
  ),
);

Shimmer listShimmer = toShimmer(
  ListTile(
    leading: CircleAvatar(
      backgroundColor: _base,
    ),
    title: textShimmer,
    subtitle: textShimmer,
  ),
);
