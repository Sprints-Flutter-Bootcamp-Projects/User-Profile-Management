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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUsers(false);
  }

  Future<void> _loadUsers(bool disallowAllowCache) async {
    setState(() {
      _isLoading = true; // Show loader
    });

    try {
      final users = await _apiService.getUsers(disallowAllowCache);
      setState(() {
        _users = users;
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: pagesAppBar(context, "Users' Profiles", () => _loadUsers(true)),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.avatar),
                      ),
                      title: Text('${user.firstName} ${user.lastName}'),
                      subtitle: Text(user.email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserDetailsPage(
                                    user: user,
                                    onUpdate: (user) async {
                                      await _apiService.updateUser(user);
                                      _loadUsers(false);
                                    },
                                    onDelete: () async {
                                      await _apiService
                                          .deleteUser(_users[index].id);
                                      _loadUsers(false);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              bool confirmDelete = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Delete User'),
                                  content: Text(
                                      'Are you sure you want to delete this user?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmDelete == true) {
                                await _apiService.deleteUser(user.id);
                                _loadUsers(false);
                              }
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDetailsPage(
                              user: user,
                              onUpdate: (user) async {
                                await _apiService.updateUser(user);
                                _loadUsers(false);
                              },
                              onDelete: () async {
                                await _apiService.deleteUser(_users[index].id);
                                _loadUsers(false);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    Divider(),
                  ],
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
                  _loadUsers(false);
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
