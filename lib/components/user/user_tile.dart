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
    StoreProvider.of<AppState>(context).dispatch(followUserAction(
      followingId: user.id,
      onFailed: (notice) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(notice.message),
        duration: notice.duration,
      )),
    ));
  }

  void _unfollowUser(BuildContext context) {
    StoreProvider.of<AppState>(context).dispatch(unfollowUserAction(
      followingId: user.id,
      onFailed: (notice) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(notice.message),
        duration: notice.duration,
      )),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(user.id.toString()),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UserPage(userId: user.id),
        ),
      ),
      leading: CircleAvatar(
        radius: 25,
        backgroundImage:
            user.avatar == '' ? null : CachedNetworkImageProvider(user.avatar),
        child: user.avatar == '' ? const Icon(Icons.person) : null,
      ),
      title: Text(user.username),
      subtitle: Text(user.intro),
      trailing: user.isFollowing
          ? TextButton(
              onPressed: () => _unfollowUser(context),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: const Text('取消关注'),
            )
          : TextButton(
              onPressed: () => _followUser(context),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: const Text('关注'),
            ),
    );
  }
}
