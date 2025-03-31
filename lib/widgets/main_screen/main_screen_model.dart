import 'package:flutter/material.dart';

const urlRegex = r'^(http|https)://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(/.*)?$';

class MainScreenModel extends ChangeNotifier {
  String _apiBaseUrl = '';

  void setApiBaseUrl(String url) {
    _apiBaseUrl = url;
  }

  bool validateApiUrl(String url){ 
    if(url.isEmpty) return false;
    if(!RegExp(urlRegex).hasMatch(url)) return false;
    return true;
  }

  

  String get apiBaseUrl => _apiBaseUrl;
}