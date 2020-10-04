import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocoon/constants/constants.dart';
import 'package:cocoon/locator.dart';
import 'package:cocoon/models/nytimes_model.dart';
import 'package:cocoon/services/navigation_service.dart';
import 'package:cocoon/ui/shared/app_colors.dart';
import 'package:cocoon/ui/shared/shared_styles.dart';
import 'package:cocoon/ui/widgets/busy_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StoryDetailView extends StatefulWidget {
  final Results results;
  StoryDetailView(this.results);

  @override
  _StoryDetailViewState createState() => _StoryDetailViewState();
}

class _StoryDetailViewState extends State<StoryDetailView> {
  final NavigationService _navService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: false,
              //pinned: true,
              expandedHeight: 300.0,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title:
                Container(
                  //height: 100,
                  //width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    //borderRadius: BorderRadius.all(Radius.circular(20)),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.results.multimedia[0].url,),
                      fit: BoxFit.cover
                    )
                  ),
                ),
              ),
            ),
            SliverList(delegate: SliverChildListDelegate(
              [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Text(widget.results.title, style: titleTextStyle,),
                  alignment: Alignment.center,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  child: Text(widget.results.updatedDate.split('T').first),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Text(widget.results.abstract, textAlign: TextAlign.center,),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    child: RaisedButton(
                      child: Text('Go Back'),
                        color: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            //side: BorderSide(color: Colors.red)
                        ),
                        onPressed: (){
                        _navService.pop();
                        }),
                    height: 50.0),
              ],
            ),)
          ],
        ),
      ),
    );
  }
}
