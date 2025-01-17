import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../screen/home_screen.dart';
import '../screen/login_screen.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  var user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
    ever(user, setInitialScreen);
  }

  void setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => HomeScreen());
    }
  }

  void register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Get.snackbar('Success', 'Account created successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar('Success', 'Logged in successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void logout() async {
    await _auth.signOut();
    Get.snackbar('Success', 'Logged out successfully');
    Get.offAll(() => LoginScreen());
  }
}
