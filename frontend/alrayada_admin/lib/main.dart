import 'package:alrayada_admin/screens/chat/s_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/user/m_user.dart';

import '/providers/p_user.dart';

import '/screens/admin/s_admin_dashboard.dart';
import '/screens/auth/auth.dart';
import '/screens/category_details/s_category_details.dart';
import '/screens/view_products/s_products.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final providerContainer = ProviderContainer();
  await providerContainer.read(UserNotifier.provider.notifier).loadSavedUser();
  runApp(UncontrolledProviderScope(
    container: providerContainer,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecommerce admin',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      routes: {
        AdminDashboardScreen.routeName: (context) =>
            const AdminDashboardScreen(),
        CategoryDetailsScreen.routeName: (context) =>
            const CategoryDetailsScreen(),
        ProductsListScreen.routeName: (context) => const ProductsListScreen(),
        ChatScreen.routeName: (context) => const ChatScreen(),
      },
      home: Consumer(
        child: const AdminDashboardScreen(),
        builder: (context, ref, dashboard) {
          final userContainer = ref.watch(UserNotifier.provider);
          if (userContainer != null &&
              userContainer.user.role == UserRole.admin) {
            return dashboard!;
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
