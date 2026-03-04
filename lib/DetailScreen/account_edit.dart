import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountEditScreen extends StatefulWidget {
  const AccountEditScreen({super.key});

  @override
  State<AccountEditScreen> createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends State<AccountEditScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    nameController.text = prefs.getString("name") ?? "";
    phoneController.text = prefs.getString("phone") ?? "";
    emailController.text = prefs.getString("email") ?? "";
    addressController.text = prefs.getString("address") ?? "";

    String ? imagePath = prefs.getString('profile_image');
    if (imagePath != null && imagePath.isNotEmpty) {
    setState(() {
      _selectedImage = File(imagePath);
    });
  }
  }

  Future<void> saveUserData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("name", nameController.text);
    await prefs.setString("phone", phoneController.text);
    await prefs.setString("email", emailController.text);
    await prefs.setString("address", addressController.text);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Data Saved Successfully")));
      Navigator.pop(context);
  }

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  /// 🔹 Open Bottom Sheet
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.red),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo, color: Colors.red),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// 🔹 Pick Image
Future<void> _pickImage(ImageSource source) async {
  final XFile? pickedFile = await _picker.pickImage(source: source);

  if (pickedFile != null) {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("profile_image", pickedFile.path); // 🔥 Save path

    setState(() {
      _selectedImage = File(pickedFile.path);
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        title: const Text("Edit Account"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// 🔹 Profile Image Section
            GestureDetector(
              onTap: _showImagePickerOptions,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : const AssetImage("assets/images/profile.png")
                              as ImageProvider,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF8E0038),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            buildTextField(
              label: "Name",
              hint: "Guest",
              icon: Icons.person,
              controller: nameController,
            ),
            const SizedBox(height: 20),

            /// 🔹 Phone Field
            buildTextField(
              label: "Phone Number",
              hint: "+91 9876543210",
              icon: Icons.phone,
              controller: phoneController,
            ),

            const SizedBox(height: 20),

            /// 🔹 Email
            buildTextField(
              label: "Email",
              hint: "Enter your email",
              icon: Icons.email,
              controller: emailController,
            ),

            const SizedBox(height: 20),

            /// 🔹 Address
            buildTextField(
              label: "Address",
              hint: "Enter your address",
              icon: Icons.location_on,
              maxLines: 3,
              controller: addressController,
            ),

            const SizedBox(height: 40),

            /// 🔹 Save Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: saveUserData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E0038),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildTextField({
  required String label,
  required String hint,
  required IconData icon,
  required TextEditingController controller,
  bool readOnly = false,
  int maxLines = 1,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ],
  );
}
