import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/p_user.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Developed by AhmedHnewa'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => ref.read(UserNotifier.provider.notifier).logout(),
            child: const Text(
              'Logout',
            ),
          ),
        ],
      ),
    );
  }
}
