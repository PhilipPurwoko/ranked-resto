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
  final ChangeNotifierProvider<RestoListProvider> _restoListProvider =
      ChangeNotifierProvider<RestoListProvider>(
    (ProviderReference ref) => RestoListProvider(),
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext ctx, ScopedReader watch, _) {
        final RestoListProvider restoListState =
            watch<RestoListProvider>(_restoListProvider);

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
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Search restaurant',
                      fillColor: Colors.white,
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : AnimatedOpacity(
                    opacity: _fadeTitle ? 0 : 1,
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
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _fadeTitle = true;
                      _searchMode = true;
                    });
                  },
                ),
            ],
          ),
          body: _searchMode
              ? const Center(child: Text('No Result Found'))
              : SafeArea(
                  child: FutureBuilder<String?>(
                    future: restoListState.loadDatabase(),
                    builder: (_, AsyncSnapshot<String?> snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Loading Error, check your network connection',
                          ),
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
                ),
        );
      },
    );
  }
}
