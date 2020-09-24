import 'dart:core';

class AtmStatus {
  static List<int> crowdedDaysRetired = [10, 11, 12];
  static List<int> crowdedDaysEmployed = [24, 25, 26, 27, 28];
  static List<int> crowdedHours = [12, 13, 14, 15];
  static String user = "متقاعد";
  static String crowdingStatus = _checkCrowding(user);

  static String _checkCrowding(String user) {
    if (user == "متقاعد") {
      if (crowdedDaysRetired.contains(DateTime.now().day) == true &&
          crowdedHours.contains(DateTime.now().hour) == true) {
        crowdingStatus = "مزدحمة حاليا";
      } else {
        crowdingStatus = "خالية حاليا";
      }
    } else if (user == "موظف") {
      if (crowdedDaysEmployed.contains(DateTime.now().day) == true &&
          crowdedHours.contains(DateTime.now().hour) == true) {
        crowdingStatus = "مزدحمة حاليا";
      } else {
        crowdingStatus = "خالية حاليا";
      }
    }
    return crowdingStatus;
  }
}
