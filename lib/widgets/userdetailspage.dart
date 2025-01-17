import 'package:flutter/material.dart';
import 'package:user_profile_management/models/user.dart';
import 'package:user_profile_management/widgets/edituserpage.dart';
import 'package:user_profile_management/services/user_cache.dart';

class UserDetailsPage extends StatelessWidget {
  final User user;
  final Function() onUpdate;
  final Function() onDelete;

  const UserDetailsPage({
    super.key,
    required this.user,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Profile"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await onDelete();
                  await UserCache().clearCache();
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
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.avatar),
                radius: 70,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text('${user.firstName} ${user.lastName}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ElevatedButton(
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
                child: Text("Edit Profile"),
                          ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      children: [
                        Icon(Icons.person),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("First Name:", style: TextStyle(fontWeight: FontWeight.bold),),
                        )
                      ],
                    ),
                  Text(' ${user.firstName}'),
                ],
              ),
            ),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      children: [
                        Icon(Icons.person),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Last Name:", style: TextStyle(fontWeight: FontWeight.bold),),
                        )
                      ],
                    ),
                  Text(' ${user.lastName}'),
                ],
              ),
            ),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      children: [
                        Icon(Icons.email_rounded),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Email:", style: TextStyle(fontWeight: FontWeight.bold),),
                        )
                      ],
                    ),
                  Text(' ${user.email}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
