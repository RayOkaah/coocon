import 'dart:convert';

import 'package:cocoon/models/nytimes_model.dart';
import 'package:cocoon/ui/viewmodels/home_view_model.dart';
import 'package:cocoon/ui/widgets/aware_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:cocoon/ui/widgets/info_list_tile.dart';

class HomeListView extends StatefulWidget {
  const HomeListView({Key key}) : super(key: key);

  @override
  _HomeListViewState createState() => _HomeListViewState();
}

class _HomeListViewState extends State<HomeListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<HomeViewModel>(
        create: (context) => HomeViewModel(),
        child: Consumer<HomeViewModel>(
          builder: (context, model, child) => RefreshIndicator(
            onRefresh: model.refresh,
            child: Stack(
              children: [
                SafeArea(
                  minimum: EdgeInsets.only(top: 50),
                  child: ListView.builder(
                    itemCount: model.resultList.length,
                    itemBuilder: (context, index) => CreationAwareListItem(
                      itemCreated: () {
                        SchedulerBinding.instance.addPostFrameCallback(
                                (duration) => model.handleItemCreated(index));
                      },
                      child: Container(
                        height: 100,
                        child: InfoListTile(
                          results: model.resultList[index],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                    child: buildFloatingSearchBar(model.resultList)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Results> displayedList = [];
  List<Results> tempList = [];
  Widget buildFloatingSearchBar(List<Results> _resultList) {
    bool isPortrait =true;

    void filterSearchResults(String query) {
     // List<String> tempList = List<String>();
      //tempList.addAll(_apodList);
      if(query.isNotEmpty) {
        print('newquery : '+query);
       // List<String> tempList = List<String>();
        _resultList.forEach((item) {
          if(item.title.contains(query)) {
            tempList.add(item);
          }
        });
        setState(() {
          print('tema here o : '+tempList.toString());
          displayedList.clear();
          displayedList.addAll(tempList);
          print('diplaya : '+displayedList.toString());
        });
        return;
      } else {
        setState(() {
          displayedList.clear();
          displayedList.addAll(_resultList);
        });
      }
    }

    return FloatingSearchBar(
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      maxWidth: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        filterSearchResults(query);
        // Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: displayedList.map((apod) {
                return Container(
                  height: 100,
                  child: InfoListTile(
                    results: apod,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
