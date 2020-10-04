import 'dart:convert';
import 'dart:io';

import 'package:cocoon/constants/constants.dart';
import 'package:cocoon/models/nytimes_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class HomeViewModel extends ChangeNotifier {
  static const int ItemRequestThreshold = 8;

  List<String> _items;
  List<String> get items => _items;

  int _count = 0;
  int get count => _count+10;
  bool listEnd = false;

  Future<List<Results>> getApodList() async{
  resultList = await getUserDataResponse();
  return resultList;
  }

  int _currentPage = 0;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  get history => resultList;
  List<Results> _suggestions = [];
  List<Results> get suggestions => resultList;

  String _query = '';
  String get query => _query;

  void clear() {
    _suggestions = history;
    notifyListeners();
  }


  HomeViewModel(){
    getApodList();
  }

  Future<void> _deleteCacheContents() async {
    final cacheDir = await getTemporaryDirectory();
    String fileName = "CacheData.json";

    if (await File(cacheDir.path + "/" + fileName).exists()) {
      cacheDir.delete(recursive: true);
      print("Deleted the CacheJson file!!");
    }
  }

  Future<void> refresh() async {
    await Future.delayed(Duration(seconds: 0, milliseconds: 2000));
    resultList.clear();
    getUserDataResponse();
    //_deleteCacheContents();
    notifyListeners();
  }

  List<Results> resultList = [];


  Future<List<Results>> getUserDataResponse() async {
    /// Step2 - Declare a file name that has .json extension and get the Cache Directory

    String fileName = "CacheData.json";
    var cacheDir = await getTemporaryDirectory();

    /// Step 3 - Check of the Json file exists so that we can decide whether to make an API call or not

    if (await File(cacheDir.path + "/" + fileName).exists()) {
      print("Loading from cache");
      //TOD0: Reading from the json File
      final jsonData = File(cacheDir.path + "/" + fileName).readAsStringSync();
      print('json datahere : '+jsonData);
      //ApiResponse response = ApiResponse.fromJson(json.decode(jsonData));
      final responseList = json.decode(jsonData);
      for(var m in responseList){
        resultList.add(Results.fromJson(m));
      }
      notifyListeners();
      return resultList;
    }
    /// If the Json file does not exist, then make the API Call

    else {
      print("Loading from API");
      final response = await fetchResultList(count);

      if (response is List<Results>) {
        //final jsonResponse = response;
        //ApiResponse res = ApiResponse.fromJson(json.decode(jsonResponse));
        var jsonResponse = jsonEncode(response.map((e) => e.toJson()).toList());

        /// Step 4  - Save the json response in the CacheData.json file in Cache
        var tempDir = await getTemporaryDirectory();
        File file = new File(tempDir.path + "/" + fileName);
        file.writeAsString(jsonResponse, flush: true, mode: FileMode.write);
        notifyListeners();
        return response;
      }

    }
  }

Future<List<Results>> fetchResultList(int itemCount) async {
    // widget.callback();
    //final response = await http.get(BASEAPIURL+"/planetary/apod?api_key=$APIKEY", headers: {
    final response = await http.get(BASEAPIURL+"?api-key=$APIKEY", headers: {
      "Accept": "application/json"
    });
    print('result : '+response.body);
    if (response.statusCode == 200) {
      Iterable responseList = json.decode(response.body)['results'];

      //apodList = responseList.map((m) => Apod.fromJson(json.decode(m))).toList();
      for(var m in responseList){
        resultList.add(Results.fromJson(m));
      }

      //_navService.navigateTo(StockDetailViewRoute, arguments: _stockEntity);
      //widget.callback();
      notifyListeners();
      return resultList;
    } else {
      // If the server did not return a 200 OK response,
      // notify Hud and then throw an exception.
      // widget.callback();
      notifyListeners();
      throw Exception('Failed to fetch apodlist');
    }
  }

  Future handleItemCreated(int index) async {
    var itemPosition = index + 1;
    var requestMoreData =
        itemPosition % ItemRequestThreshold == 0 && itemPosition != 0;
    var pageToRequest = itemPosition ~/ ItemRequestThreshold;

    if(count >=100){
      if (listEnd) {
        return;
      }
      else {
        //_showListEnding();
        return;
      }

    }
    else if (requestMoreData && pageToRequest > _currentPage) {
      print('handleItemCreated | pageToRequest: $pageToRequest');
      _currentPage = pageToRequest;
      _showLoadingIndicator();

      await Future.delayed(Duration(seconds: 3));
      //count = count + 10;
      var newFetchedItems = await getUserDataResponse(); //fetchApodList(count);
      _count = newFetchedItems.length;
       //apodList.addAll(newFetchedItems);
      //await Future.delayed(Duration(seconds: 5));
      _removeLoadingIndicator();
    }

    else {
      return;
    }

  }

  void _showLoadingIndicator() {
    resultList.add(Results(title: LoadingIndicatorTitle));
    notifyListeners();
  }

  void _showListEnding() {
    resultList.add(Results(title: ListEndText));
    listEnd = true;
    notifyListeners();
  }

  void _removeLoadingIndicator() {
    resultList.removeWhere((element) => element.title == LoadingIndicatorTitle);
    notifyListeners();
  }
}
