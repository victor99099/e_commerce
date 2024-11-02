import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ReviewController extends GetxController {
  final Uuid _uuid = const Uuid();

  // Method to generate a unique ID
  String generateUniqueId() {
    return _uuid.v4();
  }
}