import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/models.dart';
import '../../actions/actions.dart';
import '../../pages/pages.dart';

class UserTile extends StatelessWidget {
  final UserEntity user;

  const UserTile({super.key, required this.user});

  void _followUser(BuildContext context) {
    StoreProvider.of<AppState>(context).dispatch(followUserAction());
  }

  void _unfollowUser(BuildContext context) {
    StoreProvider.of<AppState>(context).dispatch(unfollowUserAction());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
