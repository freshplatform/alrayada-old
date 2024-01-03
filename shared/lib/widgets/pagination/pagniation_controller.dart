import 'package:flutter/widgets.dart';

enum PagniationControllerAction {
  none,
  refreshDataList,
  deleteItem,
  insertItem
}

@immutable
class AddItem<T> {

  const AddItem({
    required this.item,
    this.index,
  });
  final T? item;
  final int? index;
}

class PagniationController<T> with ChangeNotifier {
  var action = PagniationControllerAction.none;
  var itemIndexToDelete = 0;
  var itemToAdd = AddItem<T>(item: null);

  void refreshData() {
    action = PagniationControllerAction.refreshDataList;
    notifyListeners();
  }

  void deleteItem(int index) {
    action = PagniationControllerAction.deleteItem;
    itemIndexToDelete = index;
    notifyListeners();
  }

  void insertItem({required dynamic item, int? index}) {
    action = PagniationControllerAction.insertItem;
    itemToAdd = AddItem(item: item, index: index);
    notifyListeners();
  }
}
