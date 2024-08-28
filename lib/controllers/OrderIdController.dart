import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class OrderIdController extends GetxController {
  final Uuid _uuid = Uuid();

  // Method to generate a unique ID
  String generateUniqueId() {
    return _uuid.v4();
  }
}