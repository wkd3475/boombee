import '../globals.dart' as globals;

class Subscribe {
  String key = "subscribe";
  List<String> subscribeList = [];

  void init() async {
    subscribeList = globals.prefs.getStringList(key);
    if (subscribeList == null) {
      subscribeList = [];
    }
  }

  void add(String parkId) {
    List<String> content = subscribeList;
    bool hasParkId = false;

    for (var i=0; i<subscribeList.length; i++) {
      if (subscribeList[i] == parkId) {
        hasParkId = true;
      }
    }

    if (!hasParkId) {
      content.add(parkId);
    }

    globals.prefs.setStringList(key, content);
    subscribeList = content;
    print(subscribeList.toString());
  }

  void remove(String parkId) {
    List<String> content = subscribeList;
    bool hasParkId = false;

    for (var i=0; i<subscribeList.length; i++) {
      if (subscribeList[i] == parkId) {
        subscribeList.removeAt(i);
        hasParkId = true;
      }
    }

    if (!hasParkId) return;

    globals.prefs.setStringList(key, content);
    subscribeList = content;
    print(subscribeList.toString());
  }
}