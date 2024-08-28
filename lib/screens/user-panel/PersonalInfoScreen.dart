import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/ChangeInfoController.dart';
import 'package:flutter_application_1/models/user-model.dart';
import 'package:flutter_application_1/screens/user-panel/Profilescreen.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../widgets/DialogLogoutWidget.dart';

class UpdateUserInfoScreen extends StatelessWidget {
  UserModel userModel;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final ChangeInfoController changeInfoController =
      Get.put(ChangeInfoController());

  UpdateUserInfoScreen({super.key, required this.userModel}) {
    nameController.text = userModel.username;
    phoneController.text = userModel.phone;
    cityController.text = userModel.city;
    addressController.text = userModel.userAddress;
    streetController.text = userModel.street;
  }
  RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);

    return Scaffold(
      backgroundColor: currentTheme.primaryColor,
      appBar: AppBar(
        title: Text(
          'Update Information',
          style: TextStyle(
              color: currentTheme.colorScheme.tertiary,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: currentTheme.colorScheme.tertiary),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              controller: nameController,
              labelText: 'Name',
              icon: Icons.person,
              theme: currentTheme,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: phoneController,
              labelText: 'Phone No',
              icon: Icons.phone,
              theme: currentTheme,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: cityController,
              labelText: 'City',
              icon: Icons.terrain,
              theme: currentTheme,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: streetController,
              labelText: 'Street',
              icon: Icons.traffic,
              theme: currentTheme,
            ),
            SizedBox(height: 16),
            _buildTextArea(
              controller: addressController,
              labelText: 'Address',
              icon: Icons.home,
              theme: currentTheme,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog(
                      title: "Save Changes",
                      content: "Are you sure ?",
                      onCancel: () {
                        Navigator.of(context).pop();
                        nameController.text = userModel.username;
                        phoneController.text = userModel.phone;
                        cityController.text = userModel.city;
                        addressController.text = userModel.userAddress;
                        streetController.text = userModel.street;
                        Get.off(() => ProfileScreen());
                      },
                      onConfirm: () async {
                        Navigator.of(context).pop();

                        changeInfoController.UpdateInfo(
                            nameController.text,
                            phoneController.text,
                            cityController.text,
                            addressController.text,
                            streetController.text);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Information Updated',
                            style: TextStyle(
                                color: currentTheme.colorScheme.surface),
                          ),
                          backgroundColor: currentTheme.colorScheme.onPrimary,
                        ));
                        Get.off(() => ProfileScreen());
                      });
                });
          },
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                currentTheme.colorScheme.onPrimary,
              ),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)))),
          child: Text(
            'Save Changes',
            style: TextStyle(color: currentTheme.colorScheme.surface),
          ),
        ).h(Get.height / 16),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required ThemeData theme,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: theme.colorScheme.tertiaryFixed),
        prefixIcon: Icon(icon, color: theme.colorScheme.onPrimary),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.tertiary),
        ),
        hintStyle: TextStyle(color: theme.colorScheme.tertiaryFixed),
      ),
    );
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required ThemeData theme,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: 2,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: theme.colorScheme.tertiaryFixed),
        prefixIcon: Icon(icon, color: theme.colorScheme.onPrimary),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.tertiary),
        ),
        hintStyle: TextStyle(color: theme.colorScheme.tertiaryFixed),
      ),
    );
  }
}
