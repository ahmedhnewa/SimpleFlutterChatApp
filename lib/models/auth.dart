import 'dart:io';

class Auth {
  Auth(
      {this.isLogin = false,
      this.userEmail = '',
      this.userPassword = '',
      this.username = '',
      this.selectedImage});
  bool isLogin;
  String userEmail = '';
  String username = '';
  String userPassword = '';
  File? selectedImage;
}
