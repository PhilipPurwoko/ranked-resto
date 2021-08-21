import 'package:flutter/material.dart';

class CarouselCard extends StatelessWidget {
  const CarouselCard(
    this.name,
    this.image, {
    this.useNetwork = false,
    this.subtitle,
    this.trailing,
    Key? key,
  }) : super(key: key);

  final String name;
  final String image;
  final bool useNetwork;
  final Widget? subtitle;
  final Widget? trailing;

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
              subtitle: subtitle,
              trailing: trailing,
            ),
            child: !useNetwork
                ? Image.asset(image, fit: BoxFit.cover)
                : FadeInImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(image),
                    placeholder: const AssetImage('assets/placeholder.png'),
                  ),
          ),
        ),
      ],
    );
  }
}
