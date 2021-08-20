import 'package:flutter/material.dart';

class CarouselCard extends StatelessWidget {
  const CarouselCard(this.name, this.image, {Key? key}) : super(key: key);
  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: GridTile(
            footer: GridTileBar(
              backgroundColor: Colors.black54,
              title: Text(name),
            ),
            child: Image.asset(image, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
