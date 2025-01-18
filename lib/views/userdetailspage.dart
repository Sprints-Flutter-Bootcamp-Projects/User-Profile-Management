import 'package:flutter/material.dart';
import 'package:user_profile_management/models/user.dart';
import 'package:user_profile_management/views/edituserpage.dart';

// ignore: must_be_immutable
class UserDetailsPage extends StatefulWidget {
  User user;
  final Function(User) onUpdate;
  final Function() onDelete;

  UserDetailsPage({
    super.key,
    required this.user,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
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
                  await widget.onDelete();
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
                backgroundImage: NetworkImage(widget.user.avatar),
                radius: 70,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                '${widget.user.firstName} ${widget.user.lastName}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final User? updatedUser = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditUserPage(
                          user: widget.user,
                          onUpdate: widget.onUpdate,
                        ),
                      ),
                    );
                    if (updatedUser != null) widget.user = updatedUser;
                    setState(() {});
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
                        child: Text(
                          "First Name:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Text(' ${widget.user.firstName}'),
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
                        child: Text(
                          "Last Name:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Text(' ${widget.user.lastName}'),
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
                        child: Text(
                          "Email:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Text(' ${widget.user.email}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
