import 'package:flutter/widgets.dart' show Widget, VoidCallback;
import 'package:freezed_annotation/freezed_annotation.dart';

import '../pagniation_controller.dart';

part 'pagniation_options.freezed.dart';

@freezed
class PagniationOptions with _$PagniationOptions {
  const factory PagniationOptions({
    required Widget initLoadingIndicatorWidget,
    required Widget loadingMoreIndicatorWidget,
    required Widget Function(Object? error) initErrorHandler,
    required Function(Object error) loadingMoreErrorHandler,
    PagniationController? controller,
    VoidCallback? onReachEnd,
    PaginationState<dynamic>? initialState,
    Function(PaginationState<dynamic> newState)? onStateChanged,
  }) = _PagniationOptions;
}

@freezed
class PaginationState<T> with _$PaginationState {
  const factory PaginationState({
    @Default([]) Iterable<T> dataList,
    @Default(1) int page,
    @Default(false) bool isLoadingMore,
    @Default(true) bool isInitLoading,
    @Default(false) bool isAllLoaded,
  }) = _PagniationState;
}
