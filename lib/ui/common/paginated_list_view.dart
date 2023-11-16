import 'package:flutter/material.dart';

import '../../util/dimensions.dart';

class PaginatedListView extends StatefulWidget {
  final ScrollController scrollController;
  final Function(int offset) onPaginate;
  final int ttlSize;
  final int? offset;
  final Widget itemView;
  final bool enabledPagination;
  final bool reverse;
  final Axis scrollDirection;

  const PaginatedListView({
    super.key,
    required this.scrollController,
    required this.onPaginate,
    required int? totalSize,
    required this.offset,
    required this.itemView,
    this.enabledPagination = true,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
  }) : ttlSize = totalSize ?? 0;

  @override
  State<PaginatedListView> createState() => _PaginatedListViewState();
}

class _PaginatedListViewState extends State<PaginatedListView> {
  late int _offset;
  late List<int> _offsetList;
  bool _isLoading = false;

  final int _perPage = 10;

  @override
  void initState() {
    super.initState();

    _offset = 1;
    _offsetList = [1];

    widget.scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    if ((widget.scrollController.position.pixels == widget.scrollController.position.maxScrollExtent) &&
        !_isLoading &&
        widget.enabledPagination) {
      if (mounted) {
        _paginate();
      }
    }
  }

  void _paginate() async {
    int pageSize = (widget.ttlSize / _perPage).ceil();
    if (_offset < pageSize && !_offsetList.contains(_offset + 1)) {
      setState(() {
        _offset = _offset + 1;
        _offsetList.add(_offset);
        _isLoading = true;
      });
      await widget.onPaginate(_offset);
      setState(() {
        _isLoading = false;
      });
    } else {
      if (_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.offset != null) {
      _offset = widget.offset!;
      _offsetList = [];
      for (int index = 1; index <= widget.offset!; index++) {
        _offsetList.add(index);
      }
    }

    if (widget.scrollDirection == Axis.vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.reverse ? const SizedBox() : widget.itemView,
          ((_offset >= (widget.ttlSize / _perPage).ceil() || _offsetList.contains(_offset + 1)))
              ? const SizedBox()
              : Center(
                  child: Padding(
                  padding: (_isLoading) ? const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL) : EdgeInsets.zero,
                  child: _isLoading ? const CircularProgressIndicator() : const SizedBox(),
                )),
          widget.reverse ? widget.itemView : const SizedBox(),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.reverse ? const SizedBox() : widget.itemView,
          ((_offset >= (widget.ttlSize / _perPage).ceil() || _offsetList.contains(_offset + 1)))
              ? const SizedBox()
              : Center(
                  child: Padding(
                  padding: (_isLoading) ? const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL) : EdgeInsets.zero,
                  child: _isLoading ? const CircularProgressIndicator() : const SizedBox(),
                )),
          widget.reverse ? widget.itemView : const SizedBox(),
        ],
      );
    }
  }
}
