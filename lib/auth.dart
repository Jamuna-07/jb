import 'package:appwrite/appwrite.dart';
import 'package:jain_buzz/database.dart';
import 'package:jain_buzz/saved_data.dart';

Client client = Client()
    .setEndpoint('https://[APPWRITE-ENDPOINT]') // Your Appwrite endpoint
    .setProject('675221a3001ba9dff523'); // Your Appwrite project ID

Account account = Account(client);
// Register User
Future<String> createUser(String name, String email, String password) async {
  try {
    final user = await account.create(
        userId: ID.unique(), email: email, password: password, name: name);
    saveUserData(name, email, user.$id);
    return "success";
  } on AppwriteException catch (e) {
    return e.message.toString();
  }
}

// Login User

Future loginUser(String email, String password) async {
  try {
    final user =
        await account.createEmailSession(email: email, password: password);
    SavedData.saveUserId(user.userId);
    getUserData();
    return true;
  } on AppwriteException {
    return false;
  }
}

extension on Account {
  createEmailSession({required String email, required String password}) {}
}

// Logout the user
Future logoutUser() async {
  await account.deleteSession(sessionId: 'current');
  await SavedData.clearSavedData();
}

// check if user have an active session or not

Future checkSessions() async {
  try {
    await account.getSession(sessionId: 'current');
    return true;
  } catch (e) {
    return false;
  }
}
