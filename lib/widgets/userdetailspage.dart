import 'package:flutter/material.dart';
import 'package:user_profile_management/models/user.dart';
import 'package:user_profile_management/widgets/edituserpage.dart';

class UserDetailsPage extends StatelessWidget {
  final User user;
  final Function() onUpdate;
  final Function() onDelete;

  const UserDetailsPage({super.key, 
    required this.user,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.firstName} ${user.lastName}'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditUserPage(
                    user: user,
                    onUpdate: onUpdate,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              try {
                await onDelete();
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              } catch (e) {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete user: $e')),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.avatar),
              radius: 50,
            ),
            SizedBox(height: 20),
            Text('Name: ${user.firstName} ${user.lastName}'),
            Text('Email: ${user.email}'),
          ],
        ),
      ),
    );
  }
}