import 'dart:io';
import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:jain_buzz/constants/color.dart';
import 'package:jain_buzz/containers/custom_headtext.dart';
import 'package:jain_buzz/containers/custom_input_form.dart';
import 'package:jain_buzz/database.dart';
import 'package:jain_buzz/saved_data.dart';

import '../auth.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  Uint8List? _pickedImageBytes;
  bool _isInPersonEvent = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _guestController = TextEditingController();
  final TextEditingController _sponsersController = TextEditingController();

  Storage storage = Storage(client);
  bool isUploading = false;
  String userId = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    userId = SavedData.getUserId();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _dateTimeController.dispose();
    _guestController.dispose();
    _sponsersController.dispose();
    super.dispose();
  }

  // To pickup date and time from the user
  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDateTime.year,
          pickedDateTime.month,
          pickedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          _dateTimeController.text = selectedDateTime.toString();
        });
      }
    }
  }

  // Cross-platform image picking method
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (pickedFile != null) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _pickedImageBytes = imageBytes;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  // Upload event image to storage bucket
  Future<String?> _uploadEventImage() async {
    setState(() {
      isUploading = true;
    });

    try {
      if (_pickedImageBytes != null) {
        final inputFile = InputFile.fromBytes(
          bytes: _pickedImageBytes!,
          filename: "event_image_${DateTime.now().millisecondsSinceEpoch}.jpg",
        );

        final response = await storage.createFile(
          bucketId: '64bcdd3ad336eaa231f0',
          fileId: ID.unique(),
          file: inputFile,
        );

        return response.$id;
      } else {
        print("No image selected");
        return null;
      }
    } catch (e) {
      print('Upload error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      return null;
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  // Validate input fields
  bool _validateInputFields() {
    if (_nameController.text.isEmpty ||
        _descController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _dateTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Event Name, Description, Location, Date & Time are required."),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const CustomHeadText(text: "Create Event"),
              const SizedBox(height: 25),

              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .3,
                  decoration: BoxDecoration(
                    color: kLightGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _pickedImageBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            _pickedImageBytes!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_outlined,
                              size: 42,
                              color: Colors.black,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Add Event Image",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 8),

              // Input Fields
              CustomInputForm(
                controller: _nameController,
                icon: Icons.event_outlined,
                label: "Event Name",
                hint: "Add Event Name",
              ),
              const SizedBox(height: 8),
              CustomInputForm(
                maxLines: 4,
                controller: _descController,
                icon: Icons.description_outlined,
                label: "Description",
                hint: "Add Description",
              ),
              const SizedBox(height: 8),
              CustomInputForm(
                controller: _locationController,
                icon: Icons.location_on_outlined,
                label: "Location",
                hint: "Enter Location of Event",
              ),
              const SizedBox(height: 8),
              CustomInputForm(
                controller: _dateTimeController,
                icon: Icons.date_range_outlined,
                label: "Date & Time",
                hint: "Pickup Date Time",
                readOnly: true,
                onTap: () => _selectDateTime(context),
              ),
              const SizedBox(height: 8),
              CustomInputForm(
                controller: _guestController,
                icon: Icons.people_outlined,
                label: "Guests",
                hint: "Enter list of guests",
              ),
              const SizedBox(height: 8),
              CustomInputForm(
                controller: _sponsersController,
                icon: Icons.attach_money_outlined,
                label: "Sponsors",
                hint: "Enter Sponsors",
              ),
              const SizedBox(height: 8),

              // In-Person Event Toggle
              Row(
                children: [
                  const Text(
                    "In Person Event",
                    style: TextStyle(color: kLightGreen, fontSize: 20),
                  ),
                  const Spacer(),
                  Switch(
                    activeColor: kLightGreen,
                    focusColor: Colors.green,
                    value: _isInPersonEvent,
                    onChanged: (value) {
                      setState(() {
                        _isInPersonEvent = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Create Event Button
              SizedBox(
                height: 50,
                width: double.infinity,
                child: MaterialButton(
                  color: kLightGreen,
                  onPressed: () async {
                    // Validate inputs
                    if (!_validateInputFields()) return;

                    try {
                      // Upload image
                      String? imageId =
                          await _uploadEventImage() ?? "66629e1a0000e9198561";

                      // Create event
                      await createEvent(
                        _nameController.text,
                        _descController.text,
                        imageId,
                        _locationController.text,
                        _dateTimeController.text,
                        userId,
                        _isInPersonEvent,
                        _guestController.text,
                        _sponsersController.text,
                      );

                      // Show success message and pop the screen
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Event Created!!")));
                      Navigator.pop(context);
                    } catch (e) {
                      // Handle any errors during event creation
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Failed to create event: $e")));
                    }
                  },
                  child: const Text(
                    "Create New Event",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
