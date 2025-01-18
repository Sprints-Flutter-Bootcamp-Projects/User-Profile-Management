import 'package:flutter/material.dart';
import 'package:user_profile_management/models/user.dart';
import 'package:user_profile_management/services/api_service.dart';
import 'package:user_profile_management/views/adduserpage.dart';
import 'package:user_profile_management/views/userdetailspage.dart';
import 'package:user_profile_management/widgets/app_bar.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final ApiService _apiService = ApiService();
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await _apiService.getUsers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pagesAppBar(context, "Users' Profiles"),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.avatar),
            ),
            title: Text('${user.firstName} ${user.lastName}'),
            subtitle: Text(user.email),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetailsPage(
                    user: user,
                    onUpdate: (user) async {
                      await _apiService.updateUser(user);
                      _loadUsers();
                    },
                    onDelete: () async {
                      await _apiService.deleteUser(_users[index].id);
                      _loadUsers();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUserPage(
                onCreate: (newUser) async {
                  await _apiService.createUser(newUser);
                  _loadUsers(); // Refresh the list after creating a user
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
