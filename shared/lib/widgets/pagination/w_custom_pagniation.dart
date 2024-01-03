import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/widgets.dart';

import 'pagination_options/pagniation_options.dart';
import 'pagniation_controller.dart';

typedef PagniationLoadData<T> = Future<List<T>> Function(int page);

class PagiantionListBuilder<T> {

  const PagiantionListBuilder({
    required this.scrollController,
    required this.isLoadingMore,
    required this.dataList,
    required this.itemCount,
    required this.loadingMoreIndicatorWidget,
  });
  final ScrollController scrollController;
  final bool isLoadingMore;
  final List<T> dataList;
  final int itemCount;
  final Widget loadingMoreIndicatorWidget;
}

/// T is the item type in the list
class PaginationCustomView<T> extends StatefulWidget {
  const PaginationCustomView({
    required this.loadData, required this.options, required this.listBuilder, super.key,
  });

  /*
  Example
  PaginationListView(
      listBuilder: (pagiantionListBuilder) {
        return ListView.builder(
          controller: pagiantionListBuilder.scrollController,
          itemCount: pagiantionListBuilder.itemCount,
          itemBuilder: (context, index) {
            if (index == pagiantionListBuilder.dataList.length) {
              return pagiantionListBuilder.loadingMoreIndicatorWidget;
            }
            final item = pagiantionListBuilder.dataList[index] as T;
            return itemBuilder(context, index, item);
          },
        );
      },
      loadData: loadData,
      options: options,
    )
  */
  final Widget Function(PagiantionListBuilder pagiantionListBuilder)
      listBuilder;

  final PagniationLoadData<T> loadData;
  final PagniationOptions options;

  @override
  State<PaginationCustomView> createState() => _PaginationListViewState<T>();
}

class _PaginationListViewState<T> extends State<PaginationCustomView> {
  late Future<List<T>> _loadDataFuture;
  late final ScrollController _scrollController;

  final List<T> _dataList = [];
  var _page = 1;

  var _isLoadingMore = false;
  var _isInitLoading = true;

  var _isAllLoaded = false;
  // var _state = const PaginationState();
  Future<List<T>> _loadData() => widget.loadData(_page) as Future<List<T>>;

  @override
  void initState() {
    super.initState();
    if (widget.options.initialState != null) {
      final initialState = widget.options.initialState!;
      // _state = initialState;
      _dataList.addAll(initialState.dataList as Iterable<T>);
      _page = initialState.page;
      _isLoadingMore = initialState.isLoadingMore;
      _isInitLoading = initialState.isInitLoading;
      _isAllLoaded = initialState.isAllLoaded;
    }
    if (_isInitLoading) {
      _loadDataFuture = _loadData();
    }
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    if (widget.options.controller != null) {
      widget.options.controller?.addListener(_controllerListener);
    }
  }

  void _resetAllStates() {
    // _state = const PaginationState();
    _dataList.clear();
    _page = 1;
    _isLoadingMore = false;
    _isInitLoading = true;
    _isAllLoaded = false;
    // _notifyOnStateChanged();
  }

  // void _updateState(PaginationState newState) {
  //   _state = newState;
  //   _notifyOnStateChanged();
  // }

  // void _notifyOnStateChanged() {
  //   if (widget.options.onStateChanged == null) return;
  //   // widget.options.onStateChanged!(_state);
  //   widget.options.onStateChanged!(PaginationState(
  //     dataList: _dataList,
  //     isAllLoaded: _isAllLoaded,
  //     isInitLoading: _isInitLoading,
  //     isLoadingMore: _isLoadingMore,
  //     page: _page,
  //   ));
  // }

  void _controllerListener() {
    final pagiantionController = widget.options.controller;
    if (pagiantionController == null) return;
    switch (pagiantionController.action) {
      case PagniationControllerAction.refreshDataList:
        setState(() {
          _resetAllStates();
          _loadDataFuture = _loadData();
        });
        break;
      case PagniationControllerAction.none:
        break;
      case PagniationControllerAction.deleteItem:
        setState(() {
          _dataList.removeAt(pagiantionController.itemIndexToDelete);
        });
        break;
      case PagniationControllerAction.insertItem:
        setState(() {
          if (pagiantionController.itemToAdd.index == null) {
            _dataList.add(pagiantionController.itemToAdd.item);
            return;
          }
          _dataList.insert(
            pagiantionController.itemToAdd.index!,
            pagiantionController.itemToAdd.item,
          );
        });
        break;
    }
  }

  Future<void> _onScroll() async {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (_isAllLoaded) {
        if (kDebugMode) {
          print('Returned because all items is already loaded');
        }
        return;
      }
      try {
        setState(() {
          // _updateState(_state.copyWith(isLoadingMore: true));
          _isLoadingMore = true;
        });
        // _updateState(_state.copyWith(page: _state.page + 1));
        _page++;
        _loadDataFuture = _loadData();
        final dataList = await _loadDataFuture;
        if (dataList.isEmpty) {
          setState(() {
            // _updateState(
            //     _state.copyWith(isLoadingMore: false, isAllLoaded: true));
            _isLoadingMore = false;
            _isAllLoaded = true;
          });
          await Future.delayed(Duration.zero);
          Future.microtask(
            () {
              if (widget.options.onReachEnd != null) {
                widget.options.onReachEnd!();
              }
            },
          );
          return;
        }
        // _updateState(_state.copyWith(dataList: dataList));
        _dataList.addAll(dataList);
      } catch (e) {
        widget.options.loadingMoreErrorHandler(e);
      } finally {
        setState(() {
          // _updateState(_state.copyWith(isLoadingMore: false));
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  void dispose() {
    if (widget.options.controller != null) {
      widget.options.controller?.removeListener(_controllerListener);
      widget.options.controller?.dispose();
    }
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Widget get _list {
    return widget.listBuilder(
      PagiantionListBuilder(
        scrollController: _scrollController,
        dataList: _dataList,
        isLoadingMore: _isLoadingMore,
        itemCount: _isLoadingMore ? _dataList.length + 1 : _dataList.length,
        loadingMoreIndicatorWidget: widget.options.loadingMoreIndicatorWidget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitLoading) {
      return _list;
    }
    return FutureBuilder(
      future: _loadDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.options.initLoadingIndicatorWidget;
        }
        if (snapshot.hasError) {
          return widget.options.initErrorHandler(snapshot.error);
        }
        // _updateState(_state.copyWith(isInitLoading: false));
        _isInitLoading = false;
        final dataLsit = snapshot.requireData;
        if (dataLsit.isEmpty) {
          return const Center(
            child: Text('No data'),
          );
        }
        // _updateState(_state.copyWith(dataList: dataLsit));
        _dataList.addAll(dataLsit);
        return _list;
      },
    );
  }
}
