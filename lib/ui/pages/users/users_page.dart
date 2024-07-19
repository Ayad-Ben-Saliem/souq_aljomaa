import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:souq_aljomaa/models/user.dart';
import 'package:souq_aljomaa/ui/pages/home_page/home_page.dart';
import 'package:souq_aljomaa/ui/pages/users/add_edit_user_form.dart';

final getUsers = FutureProvider((ref) => userController.getUsers());

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المستخدمين'),
          centerTitle: true,
        ),
        body: const UsersView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(context: context, builder: (context) => const Dialog(child: AddEditUserForm()));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class UsersView extends ConsumerWidget {
  const UsersView({super.key});

  @override
  Widget build(context, ref) {
    final gettingUsers = ref.watch(getUsers);

    return gettingUsers.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (users) {
        final crossAxisCount = MediaQuery.of(context).size.width / 256;
        return GridView.count(
          crossAxisCount: crossAxisCount.round(),
          padding: const EdgeInsets.all(4),
          children: [for (final user in users) UserCard(user: user)],
        );
      },
    );
  }
}

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(user.name ?? 'User', style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          Text('(${user.username!})'),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => showDialog(context: context, builder: (context) => Dialog(child: AddEditUserForm(user: user))),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('تعديل'), SizedBox(width: 8), Icon(Icons.edit)],
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => showDialog(context: context, builder: (context) => deleteUserDialog(context)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('حذف', style: TextStyle(color: Colors.red)),
                      SizedBox(width: 8),
                      Icon(Icons.delete, color: Colors.red),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget deleteUserDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('حذف مستخدم'),
      content: Text('هل أنت متأكد من أنك تريد فعلا حذف المستخدم ${user.fullName}'),
      actions: [
        ElevatedButton(
          onPressed: () {
            userController.deleteUser(user).then((deleted) {
              final width = MediaQuery.of(context).size.width;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.symmetric(horizontal: width / 2 - 128, vertical: 24),
                  content: Center(child: Text(deleted ? 'تم حذف المستخدم بنجاح' : 'لم يتم حذف المستخدم')),
                ),
              );
            });
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('نعم'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
          child: const Text('لا'),
        ),
      ],
    );
  }
}
