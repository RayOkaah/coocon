


import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocoon/constants/constants.dart';
import 'package:cocoon/constants/route_names.dart';
import 'package:cocoon/locator.dart';
import 'package:cocoon/models/nytimes_model.dart';
import 'package:cocoon/services/firestore_service.dart';
import 'package:cocoon/services/navigation_service.dart';
import 'package:cocoon/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class InfoListTile extends StatefulWidget {
  Results results;
  InfoListTile({this.results});
  @override
  _InfoListTileState createState() => _InfoListTileState();
}

class _InfoListTileState extends State<InfoListTile> {
  bool bookmarked = false;
  final NavigationService _navService = locator<NavigationService>();

  final FirestoreService _firestoreService = locator<FirestoreService>();

  onClick(){
    _navService.navigateTo(StoryDetailViewRoute, arguments: widget.results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.results.title == LoadingIndicatorTitle
          ? Center(child: CircularProgressIndicator())
          : widget.results.title == ListEndText ? Center(child: Text(widget.results.title),)
          : ListTile(
        onTap: (){
          onClick();
        },
        contentPadding: EdgeInsets.all(10),
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(widget.results.multimedia[0].url??' '),
          //child: CachedNetworkImage(imageUrl: widget.apod.url??' ',)
        ),
        title: Text(widget.results.title?? ' '),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(widget.results.updatedDate.split('T').first),
        ),
        trailing: Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            height: 40, width: 40,
            child: LikeButton(
              size: 20,
              likeBuilder: (bool isLiked) {
                bookmarked = isLiked;
                return Icon(
                  Icons.bookmark,
                  color: isLiked ? primaryColor : Colors.grey,
                  size: 20,
                );
              },
            )),
      ),
    );
  }
}
