import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rankedresto/provider/resto_list_provider.dart';
import 'package:rankedresto/widget/resto_card.dart';

class RestoList extends StatefulWidget {
  static const String routeName = 'resto-list';
  @override
  _RestoListState createState() => _RestoListState();
}

class _RestoListState extends State<RestoList> {
  bool _searchMode = false;
  bool _fadeTitle = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _searchMode
            ? IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchMode = false;
                    _fadeTitle = false;
                  });
                },
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        title: _searchMode
            ? TextField(
                controller: _searchController,
                focusNode: _focusNode,
                autofocus: true,
                cursorColor: const Color(0xFF98ee99),
                decoration: const InputDecoration(
                  labelText: 'Search restaurant',
                  fillColor: Color(0xFF98ee99),
                  labelStyle: TextStyle(
                    color: Color(0xFF98ee99),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF98ee99),
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF98ee99),
                    ),
                  ),
                ),
                // onChanged: (String name) =>
                //     restaurantProvider.searchResto(name),
                // onSubmitted: (String name) =>
                //     restaurantProvider.searchResto(name),
              )
            : AnimatedOpacity(
                opacity: _fadeTitle ? 0 : 1,
                onEnd: () {
                  setState(() {
                    _searchMode = !_searchMode;
                  });
                },
                duration: const Duration(milliseconds: 300),
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  displayFullTextOnTap: true,
                  animatedTexts: <TypewriterAnimatedText>[
                    TypewriterAnimatedText(
                      'Ranked Resto',
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                ),
              ),
        actions: <IconButton>[
          if (!_searchMode)
            IconButton(
              onPressed: () {
                setState(() {
                  _fadeTitle = true;
                });
              },
              icon: const Icon(Icons.search),
            ),
        ],
      ),
      body: RestoListWidget(),
    );
  }
}

class RestoListWidget extends ConsumerWidget {
  RestoListWidget({
    Key? key,
  }) : super(key: key);

  final ChangeNotifierProvider<RestoListProvider> _restoListProvider =
      ChangeNotifierProvider<RestoListProvider>(
    (ProviderReference ref) => RestoListProvider(),
  );

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final RestoListProvider restoListState =
        watch<RestoListProvider>(_restoListProvider);

    return SafeArea(
      child: restoListState.restaurants == null
          ? const Center(child: CircularProgressIndicator())
          : restoListState.restaurants!.isEmpty
              ? const Center(child: Text('Not Found'))
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: restoListState.restaurants!.length,
                  itemBuilder: (_, int index) => RestoCard(
                    restoListState.restaurants![index],
                  ),
                ),
    );
  }
}
