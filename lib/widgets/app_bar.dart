// ignore: non_constant_identifier_names
import 'package:flutter/material.dart';

PreferredSizeWidget pagesAppBar(BuildContext context, String appBarTitle, VoidCallback onRefresh) {
  return AppBar(
    iconTheme: IconThemeData(color: Colors.teal[900]),
    backgroundColor: Colors.white,
    shadowColor: Colors.grey[100],
    elevation: 1,
    centerTitle: true,
    title: Text(
      appBarTitle,
      style: TextStyle(color: Colors.teal[900]),
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.refresh, color: Colors.teal[900]), // Refresh icon
        onPressed: onRefresh, // Call the refresh callback
      ),
    ],
  );
}
