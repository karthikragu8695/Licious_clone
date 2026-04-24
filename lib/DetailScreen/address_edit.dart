import 'package:flutter/material.dart';

class AddressFormScreen extends StatefulWidget {
  final String? existingAddress;
  const AddressFormScreen({super.key, this.existingAddress});

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.existingAddress != null) {
      final parts = widget.existingAddress!.split(",");

      if (parts.length >= 5) {
        nameController.text = parts[0].trim();
        houseController.text = parts[1].trim();
        streetController.text = parts[2].trim();

        final cityPin = parts[3].split("-");
        cityController.text = cityPin[0].trim();
        pincodeController.text = cityPin.length > 1 ? cityPin[1].trim() : "";

        phoneController.text = parts[4].replaceAll("Phone:", "").trim();
      }
    }
  }

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final houseController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final pincodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingAddress == null ? "Add Address" : "Update Address",
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField("Full Name", nameController, TextInputType.text),
            buildTextField(
              "Phone Number",
              phoneController,
              TextInputType.number,
            ),
            buildTextField(
              "House / Flat No",
              houseController,
              TextInputType.text,
            ),
            buildTextField(
              "Street / Area",
              streetController,
              TextInputType.text,
            ),
            buildTextField("City", cityController, TextInputType.text),
            buildTextField("Pincode", pincodeController, TextInputType.number),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  houseController.text.isNotEmpty &&
                  streetController.text.isNotEmpty &&
                  cityController.text.isNotEmpty &&
                  pincodeController.text.isNotEmpty) {
                String address =
                    "${nameController.text}, ${houseController.text}, "
                    "${streetController.text}, ${cityController.text} - ${pincodeController.text}, "
                    "Phone: ${phoneController.text}";
          
                Navigator.pop(context, address);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill the details")),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Color(0xFF8E0038),
            ),
            child: Text(
              widget.existingAddress == null
                  ? "Save Address"
                  : "Update Address",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller,
    TextInputType keyboardType,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,

        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
