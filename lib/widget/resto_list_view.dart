import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rankedresto/provider/resto_list_provider.dart';
import 'package:rankedresto/widget/resto_card.dart';

class RestoListWidget extends ConsumerWidget {
  const RestoListWidget(
    this.restoListProvider, {
    Key? key,
  }) : super(key: key);

  final ChangeNotifierProvider<RestoListProvider> restoListProvider;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final RestoListProvider restoListState =
        watch<RestoListProvider>(restoListProvider);

    return SafeArea(
      child: FutureBuilder<void>(
        future: restoListState.loadDatabase(),
        builder: (_, AsyncSnapshot<void> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Loading Error, check your network connection'),
            );
          } else if (restoListState.restaurants.isNotEmpty) {
            return restoListState.restaurants.isEmpty
                ? const Center(child: Text('Not Found'))
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: restoListState.restaurants.length,
                    itemBuilder: (_, int index) => RestoCard(
                      restoListState.restaurants[index],
                    ),
                  );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
