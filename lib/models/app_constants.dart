
import 'package:ikasoweb/models/contact_model.dart';
import 'package:ikasoweb/models/user_model.dart';

class AppConstants {
  static UserModel currentUser = UserModel();
  ContactModel CreateContactFromUserModel() {
    return ContactModel(
      id: currentUser.id,
      firstName: currentUser.firstName,
      lastName: currentUser.lastName,
      displayImage: currentUser.displayImage,
    );
  }
}
