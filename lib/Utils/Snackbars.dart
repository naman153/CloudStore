import 'dart:ui';

import 'package:flutter/material.dart';

SnackBar sbLoading(String text) {
  return SnackBar(
    duration: Duration(seconds: 100),
    content: Row(
      children: [
        CircularProgressIndicator(
          value: null,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              '\t' + text,
              style: TextStyle(color: Colors.white), maxLines: 2,overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

      ],
    ),
    backgroundColor: Colors.blue,
  );
}

SnackBar sbSuccess(String text) {
  return SnackBar(
    duration: Duration(seconds: 3),
    content: Row(
      children: [
        Icon(Icons.verified_outlined, color: Colors.white,),
        Text(
          '\t' + text,
          style: TextStyle(color: Colors.white),
        ),
      ],
    ),
    backgroundColor: Colors.green,
  );
}

SnackBar sbError(String text) {
  return SnackBar(
      duration: Duration(seconds: 3),
      content: Row(
        children: [
          Icon(Icons.error, color: Colors.white,),
          Expanded(
            child: Text(
              '\t' + text,
              style: TextStyle(color: Colors.white),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red);
}
