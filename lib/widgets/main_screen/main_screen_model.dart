const _urlRegex = r'^(http|https)://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(/.*)?$';

class MainScreenModel{
  bool validateApiUrl(String url){ 
    if(url.isEmpty) return false;
    if(!RegExp(_urlRegex).hasMatch(url)) return false;
    return true;
  }
}