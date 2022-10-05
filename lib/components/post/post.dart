import 'package:dou_fire/theme.dart';
import 'package:dou_fire/utils/number.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/models.dart';
import '../../components/components.dart';
import '../../actions/actions.dart';
import '../../pages/pages.dart';

class Post extends StatefulWidget {
  final PostEntity post;

  const Post({super.key, required this.post});

  @override
  State<StatefulWidget> createState() {
    return _PostState();
  }
}

class _PostState extends State<Post> {
  var _isLoading = false;

  void _likePost(BuildContext context, _ViewModel vm) {
    setState(() {
      _isLoading = true;
    });

    final store = StoreProvider.of<AppState>(context);
    store.dispatch(
      likePostAction(
        postId: widget.post.id,
        onSucceed: () {
          setState(() {
            _isLoading = false;
          });
        },
        onFailed: (notice) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(notice.message),
            duration: notice.duration,
          ));
        },
      ),
    );
  }

  void _unlikePost(BuildContext context, _ViewModel vm) {
    setState(() {
      _isLoading = true;
    });

    final store = StoreProvider.of<AppState>(context);
    store.dispatch(
      unlikePostAction(
        postId: widget.post.id,
        onSucceed: () {
          setState(() {
            _isLoading = false;
          });
        },
        onFailed: (notice) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(notice.message),
            duration: notice.duration,
          ));
        },
      ),
    );
  }

  void _deletePost(BuildContext context, _ViewModel vm) {
    showDialog(
      context: context,
      barrierDismissible: false, //是否蒙层可点击
      builder: (c) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('是否确认删除动态?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              Navigator.of(context, rootNavigator: true).pop();

              final store = StoreProvider.of<AppState>(context);
              store.dispatch(deletePostAction(
                post: widget.post,
                onSucceed: () {
                  setState(() {
                    _isLoading = false;
                  });
                },
                onFailed: (notice) {
                  setState(() {
                    _isLoading = false;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(notice.message),
                      duration: notice.duration,
                    ),
                  );
                },
              ));
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, _ViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: Feedback.wrapForTap(
                      () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UserPage(
                                userId: widget.post.creatorId,
                              ),
                            ),
                          ),
                      context),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundImage: vm.creator.avatar == ''
                        ? null
                        : CachedNetworkImageProvider(vm.creator.avatar),
                    child: vm.creator.avatar == '' ? Icon(Icons.person) : null,
                  ),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: Feedback.wrapForTap(
                        () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => UserPage(
                                  userId: widget.post.creatorId,
                                ),
                              ),
                            ),
                        context),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        vm.creator.username,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: DFTheme.fontSizeLarge,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            widget.post.createdAt.toString().substring(0, 16),
            style: TextStyle(
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildText(String text) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  Widget _buildImages(List<PostImage> images) {
    return LayoutBuilder(builder: (context, constraints) {
      const double margin = 5;
      const columns = 3;
      final width = (constraints.maxWidth - (columns - 1) * margin) / columns;
      final height = width;

      return Wrap(
        spacing: margin,
        runSpacing: margin,
        children: images
            .asMap()
            .entries
            .map<Widget>(
              (entry) => GestureDetector(
                onTap: Feedback.wrapForTap(
                    () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ImagesPlayerPage(
                            images: images
                                .map<ImageEntity>((image) => image.original)
                                .toList(),
                            initialIndex: entry.key,
                          ),
                        )),
                    context),
                child: CachedNetworkImage(
                  imageUrl: entry.value.thumb.url,
                  fit: BoxFit.cover,
                  width: width,
                  height: height,
                ),
              ),
            )
            .toList(),
      );
    });
  }

  Widget _buildVideo() {
    return VideoPlayerWithCover(video: widget.post.video!);
  }

  Widget _buildBody(BuildContext context) {
    switch (widget.post.type) {
      case PostType.text:
        return Column(
          children: <Widget>[
            _buildText(widget.post.text),
          ],
        );
      case PostType.image:
        return Column(
          children: <Widget>[
            _buildText(widget.post.text),
            _buildImages(widget.post.images),
          ],
        );
      case PostType.video:
        return Column(
          children: <Widget>[
            _buildText(widget.post.text),
            _buildVideo(),
          ],
        );
      default:
        return const Divider(height: 1);
    }
  }

  Widget _buildFooter(BuildContext context, _ViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.whatshot,
                  color: Theme.of(context).hintColor,
                  size: 20,
                ),
                Text(
                  numberWithProperUnit(widget.post.likeCount),
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              widget.post.isLiked
                  ? GestureDetector(
                      onTap: Feedback.wrapForTap(
                          () => _unlikePost(context, vm), context),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                          Icons.favorite,
                          size: 20,
                          color: DFTheme.redLight,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: Feedback.wrapForTap(
                          () => _likePost(context, vm), context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Icon(
                          Icons.favorite_border,
                          size: 20,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
              Visibility(
                visible: widget.post.creatorId == vm.user.id,
                child: GestureDetector(
                  onTap: Feedback.wrapForTap(
                      () => _deletePost(context, vm), context),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel(
        creator:
            store.state.userState.users[widget.post.creatorId.toString()] ??
                UserEntity(),
        user: store.state.accountState.user,
      ),
      builder: (context, vm) => Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Card(
            child: Column(
              children: <Widget>[
                _buildHeader(context, vm),
                const Divider(height: 1),
                _buildBody(context),
                const Divider(height: 1),
                _buildFooter(context, vm),
              ],
            ),
          ),
          Visibility(
            visible: _isLoading,
            child: const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}

class _ViewModel {
  final UserEntity creator;
  final UserEntity user;
  _ViewModel({required this.creator, required this.user});
}
