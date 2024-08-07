import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../data/app_provider.dart';
import '../../../data/notification_msg.dart';

class NotificationButton extends ConsumerWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = ref.watch(getAppColor);




    return MenuAnchor(
      onClose: () {
        // Future.delayed(const Duration(seconds: 1), () {
        //   ref.invalidate(countNotiProvider);
        // });
      },
      style: const MenuStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(Colors.transparent),
        elevation: WidgetStatePropertyAll<double>(0),
        padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.only(right: 8),
        ),
      ),
      menuChildren: [
        Card(
          elevation: 1,
          child: Container(
              decoration: BoxDecoration(
                color: appColors.notificationExpandBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              width: 300,
              height: 600,
              child: NotificationListView(
                textColor: appColors.textColor,
                warningColor: appColors.notificationWarning,
              )
          ),
        ),
      ],
      builder: (context, controller, child) {
        return IconButton(
          color: appColors.accountColor,
          icon: const Icon(Icons.notifications),
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
    );
  }
}

class NotificationMsgView extends StatelessWidget {
  final NotificationMsg msg;
  final Color textColor;
  final Color warningColor;
  const NotificationMsgView({
    super.key,
    required this.msg,
    required this.textColor,
    required this.warningColor,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(msg.image.isNotEmpty) {
      return Container(
        color: msg.isAlert ? warningColor : Colors.transparent,
        child: ListTile(
          tileColor: msg.isAlert ? warningColor : null,
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: CachedNetworkImageProvider(msg.image),
          ),
          title: Text(
            msg.title,
            style: TextStyle (
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          subtitle: Text(
            msg.data,
            style: TextStyle (
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          onTap: () {

          }
        ),
      );
    } else {
      return Container(
        color: msg.isAlert ? warningColor : Colors.transparent,
        child: ListTile(
          tileColor: msg.isAlert ? warningColor : null,
          title: Text(
            msg.title,
            style: TextStyle (
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          subtitle: Text(
            msg.data,
            style: TextStyle (
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          onTap: () {

          }
        ),
      );
    }
  }
}

class NotificationListView extends ConsumerStatefulWidget {
  final Color textColor;
  final Color warningColor;
  const NotificationListView({super.key, required this.textColor, required this.warningColor});
  @override
  _NotificationListViewState createState() => _NotificationListViewState();
}

class _NotificationListViewState extends ConsumerState<NotificationListView> {
  static const _pageSize = 20;
  final PagingController<int, NotificationMsg> _pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: 5);
  final ScrollController _scrollController = ScrollController();
  int _limit_data = 0;
  final List<NotificationMsg> _test_data = [];

  void initTestData() {
    for(int i = 0; i < 1000; i++) {
      _test_data.add(NotificationMsg(code: "$i", image: "", title: "Title $i", data: "Item $i", isAlert: i%3 == 0? true : false));
    }
    _limit_data = _test_data.length;
  }

  Future<List<NotificationMsg>> getTestData(int index, int count) {
    return Future.delayed(const Duration(milliseconds: 100), () {
      int end = index + count;
      if(end >= _limit_data) {
        end = _limit_data;
      }
      return _test_data.getRange(index, end).toList();
    });
  }

  Widget buildShowNotification(NotificationMsg msg) {
    if(msg.image.isNotEmpty) {
      return Container(
        color: msg.isAlert ? widget.warningColor : Colors.transparent,
        child: ListTile(
            tileColor: msg.isAlert ? widget.warningColor : null,
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: CachedNetworkImageProvider(msg.image),
            ),
            title: Text(
              msg.title,
              style: TextStyle (
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                color: widget.textColor,
              ),
            ),
            subtitle: Text(
              msg.data,
              style: TextStyle (
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal,
                color: widget.textColor,
              ),
            ),
            onTap: () {

            }
        ),
      );
    } else {
      return Container(
        color: msg.isAlert ? widget.warningColor : Colors.transparent,
        child: ListTile(
            tileColor: msg.isAlert ? widget.warningColor : null,
            title: Text(
              msg.title,
              style: TextStyle (
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                color: widget.textColor,
              ),
            ),
            subtitle: Text(
              msg.data,
              style: TextStyle (
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal,
                color: widget.textColor,
              ),
            ),
            onTap: () {

            }
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    initTestData();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await getTestData(pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      width: 300,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: Scrollbar(
          thumbVisibility: true,
          controller: _scrollController,
          child: RefreshIndicator(
            onRefresh: () {
              return Future.sync(() {
                _pagingController.refresh();
              });
            },
            child:PagedListView<int, NotificationMsg>(
              pagingController: _pagingController,
              scrollController: _scrollController,
              builderDelegate: PagedChildBuilderDelegate<NotificationMsg>(
                itemBuilder: (context, item, index) {
                  return buildShowNotification(item);
                  // return NotificationMsgView(
                  //   msg: item,
                  //   textColor: widget.textColor,
                  //   warningColor: widget.warningColor,
                  // );
                },
                noItemsFoundIndicatorBuilder: (context) => const Center(child: Text("Empty")),
              ),
              reverse: false,
              primary: false,
              //scrollDirection: Axis.horizontal,
            ),
          ),
        ),
      ),
    );
  }
}