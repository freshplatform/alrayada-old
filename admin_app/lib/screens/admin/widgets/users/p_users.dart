// import 'package:alrayada_admin/providers/p_admin_user.dart';
// import 'package:alrayada_admin/screens/admin/widgets/users/w_user_item.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_alrayada/data/user/m_user.dart';

// class UserPage extends ConsumerStatefulWidget {
//   const UserPage({super.key});

//   @override
//   ConsumerState<UserPage> createState() => _UserPageState();
// }

// class _UserPageState extends ConsumerState<UserPage> {
//   late final ScrollController _scrollController;

//   var _isLoadingMore = false;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     _scrollController.addListener(_scrollListener);
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     if (_searchController.text.isNotEmpty) {
//       final userProvider = ref.read(AdminUserNotifier.provider.notifier);
//       userProvider.resetPage();
//       userProvider.clearUsers();
//       userProvider.isInitLoading = true;
//     }
//     super.dispose();
//   }

//   void setLoading(bool value) => setState(() {
//         _isLoadingMore = value;
//       });

//   void _scrollListener() async {
//     if (_scrollController.position.maxScrollExtent !=
//             _scrollController.position.pixels ||
//         _provider.isAllLoadded) {
//       return;
//     }
//     setLoading(true);
//     _provider.page++;
//     await _provider.loadUsers();
//     setLoading(false);
//   }

//   List<User> get users => _provider.users;
//   final _searchController = TextEditingController();

//   Widget get content => NavigationView(
//         appBar: NavigationAppBar(
//           automaticallyImplyLeading: false,
//           leading: Tooltip(
//             message: 'Refresh',
//             child: IconButton(
//               icon: const Icon(FluentIcons.refresh),
//               onPressed: () async {
//                 setState(() {
//                   _searchController.clear();
//                   _isLoadingMore = false;
//                   _provider.reset(isInitLoading: true);
//                 });
//               },
//             ),
//           ),
//           actions: Center(
//             child: SizedBox(
//               width: 400,
//               child: TextBox(
//                 placeholder: 'Search...',
//                 controller: _searchController,
//                 textInputAction: TextInputAction.search,
//                 textAlign: TextAlign.center,
//                 keyboardType: TextInputType.text,
//                 onChanged: (value) async {
//                   if (value.isEmpty) {
//                     setState(() {
//                       _provider.reset();
//                       _isLoadingMore = true;
//                     });
//                     await _provider.loadUsers();
//                     setState(() {
//                       _searchController.text = '';
//                       _isLoadingMore = false;
//                     });
//                   }
//                 },
//                 onSubmitted: (value) async {
//                   setState(() {
//                     _provider.reset();
//                     _isLoadingMore = true;
//                   });
//                   await _provider.loadUsers(searchQuery: value);
//                   setState(() {
//                     _isLoadingMore = false;
//                   });
//                 },
//               ),
//             ),
//           ),
//         ),
//         content: ListView.builder(
//           controller: _scrollController,
//           itemCount: _isLoadingMore ? users.length + 1 : users.length,
//           itemBuilder: (context, index) {
//             if (!(index < users.length)) {
//               return const ProgressBar();
//             }
//             return ChangeNotifierProvider.value(
//               value: users[index],
//               builder: (context, child) => UserItem(
//                 index: index,
//                 onDelete: (index, item) {
//                   setState(() {
//                     // no need to delete it from the provider users list as it's already deleted
//                   });
//                 },
//               ),
//             );
//           },
//         ),
//       );

//   @override
//   Widget build(BuildContext context) {
//     if (!_provider.isInitLoading) {
//       return content;
//     }
//     return FutureBuilder(
//       future: _provider.loadUsers(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: ProgressRing(),
//           );
//         }
//         if (snapshot.hasError) {
//           return Center(
//             child: Text('Error: ${(snapshot.error.toString())}'),
//           );
//         }
//         _provider.isInitLoading = false;
//         return content;
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/user/m_user.dart';
import 'package:shared_alrayada/widgets/pagination/pagination_options/pagniation_options.dart';
import 'package:shared_alrayada/widgets/pagination/pagniation_controller.dart';
import 'package:shared_alrayada/widgets/pagination/w_pagination_list_view.dart';

import '../../../../providers/p_admin_user.dart';
import 'w_user_item.dart';

class UserPage extends ConsumerStatefulWidget {
  const UserPage({super.key});

  @override
  ConsumerState<UserPage> createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage>
    with AutomaticKeepAliveClientMixin {
  final _searchController = TextEditingController();
  final _pagniationController = PagniationController<User>();
  var _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Tooltip(
          message: 'Refresh',
          child: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _pagniationController.refreshData,
          ),
        ),
        actions: [
          Center(
            child: SizedBox(
              width: 400,
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Search...'),
                controller: _searchController,
                textInputAction: TextInputAction.search,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  if (value.trim().isEmpty && _searchQuery.trim().isNotEmpty) {
                    _searchQuery = '';
                    _pagniationController.refreshData();
                  }
                },
                onFieldSubmitted: (value) {
                  _searchQuery = value;
                  _pagniationController.refreshData();
                },
              ),
            ),
          )
        ],
      ),
      body: Builder(
        builder: (context) {
          final userAdminProvider =
              ref.read(AdminUsersNotifier.provider.notifier);
          return PagniationListView(
            loadData: (page) {
              return userAdminProvider.loadUsers(
                  page: page, searchQuery: _searchQuery);
            },
            itemBuilder: (context, index, item) {
              return UserItem(
                index: index,
                unWatchedUser: item,
                onDeleteItem: _pagniationController.deleteItem,
              );
            },
            options: PagniationOptions(
              controller: _pagniationController,
              onReachEnd: () {
                final messenger = ScaffoldMessenger.of(context);
                messenger.clearSnackBars();
                messenger.showSnackBar(const SnackBar(
                    content: SnackBar(
                  content: Text('Reached end'),
                )));
              },
              initErrorHandler: (error) {
                return Center(
                  child: Text(error.toString()),
                );
              },
              initLoadingIndicatorWidget: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              loadingMoreIndicatorWidget: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              loadingMoreErrorHandler: (error) {},
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
