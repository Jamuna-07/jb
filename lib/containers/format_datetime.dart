import 'package:intl/intl.dart';

String formatTime(String time) {
  try {
    DateTime dateTime = DateTime.parse(time);
    String formattedTime = DateFormat('h:mm a').format(dateTime);
    return formattedTime;
  } catch (e) {
    return 'Invalid time format';
  }
}

String formatDate(String date) {
  try {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat('d MMMM yyyy').format(dateTime);
    return formattedDate;
  } catch (e) {
    return 'Invalid date format';
  }
}
