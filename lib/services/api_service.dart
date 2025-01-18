import 'package:dio/dio.dart';
import 'package:user_profile_management/models/user.dart';
import 'package:user_profile_management/services/user_cache.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://reqres.in/api'));

  // Fetch users with caching
  Future<List<User>> getUsers(bool disallowAllowCache) async {
    try {
      // Try to load cached users first
      if(!disallowAllowCache){
        final cachedUsers = await UserCache.getUsers();
        if (cachedUsers.isNotEmpty) {
          return cachedUsers;
        }
      }

      // If no cached data, fetch from API
      final response = await _dio.get('/users');
      final users = (response.data['data'] as List)
          .map((user) => User.fromJson(user))
          .toList();

      // Save fetched users to cache
      await UserCache.saveUsers(users);
      return users;
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  // Create a new user
  Future<User> createUser(User user) async {
    try {
      final response = await _dio.post('/users', data: user.toJson());
      final newUser = User.fromJson(response.data);

      // Update cache with the new user
      final cachedUsers = await UserCache.getUsers();
      cachedUsers.add(newUser);
      await UserCache.saveUsers(cachedUsers);

      return newUser;
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  // Update a user
  Future<User> updateUser(User user) async {
    try {
      final response = await _dio.put('/users/${user.id}', data: user.toJson());
      final updatedUser = User.fromJson(response.data);

      // Update cache with the updated user
      final cachedUsers = await UserCache.getUsers();
      final index = cachedUsers.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        cachedUsers[index] = updatedUser;
        await UserCache.saveUsers(cachedUsers);
      }

      return updatedUser;
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Delete a user
  Future<void> deleteUser(String id) async {
    try {
      await _dio.delete('/users/$id');

      // Remove the user from the cache
      final cachedUsers = await UserCache.getUsers();
      cachedUsers.removeWhere((user) => user.id == id);
      await UserCache.saveUsers(cachedUsers);
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}