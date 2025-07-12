import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class LostFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lost & Found Module'),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Report and Find Lost Items',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReportLostItemPage()),
                  );
                },
                icon: Icon(Icons.report, color: Colors.white),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: Text('Report Lost Item', style: TextStyle(color: Colors.white)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewFoundItemPage(itemId: 1)),
                  );
                },
                icon: Icon(Icons.visibility, color: Colors.white),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: Text('View Found Items', style: TextStyle(color: Colors.white)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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

class ReportLostItemPage extends StatefulWidget {
  @override
  _ReportLostItemPageState createState() => _ReportLostItemPageState();
}

class _ReportLostItemPageState extends State<ReportLostItemPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

Future<void> _submitForm() async {
  final uri = Uri.parse('http://127.0.0.1:8000/lost-items/');
  var request = http.MultipartRequest('POST', uri);

  request.fields['name'] = nameController.text;
  request.fields['description'] = descriptionController.text;
  request.fields['location'] = locationController.text;
  request.fields['date_lost'] = dateController.text;
  request.fields['contact_info'] = contactController.text;

  if (_image != null) {
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
  }

  try {
    var response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item reported successfully')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to report item')));
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Lost Item'),
        backgroundColor: Colors.blueAccent,
      ), 
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 6,
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Report Lost Item", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      _buildTextField(nameController, 'Name', 'Please enter your name'),
                      SizedBox(height: 12),
                      _buildTextField(descriptionController, 'Description', 'Please enter a description'),
                      SizedBox(height: 12),
                      _buildTextField(locationController, 'Location', 'Please enter the location'),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: dateController,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Date of Lost',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildTextField(contactController, 'Contact Info', null, TextInputType.phone),
                      SizedBox(height: 18),
                      _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(_image!, height: 150, fit: BoxFit.cover))
                          : Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Icon(Icons.image, size: 50, color: Colors.grey)),
                      SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(Icons.upload, color: Colors.white),
                        label: Text("Upload Image", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _submitForm();
                          }
                        },
                        child: Text('Submit', style: TextStyle(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String? validatorMsg,
      [TextInputType type = TextInputType.text]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      keyboardType: type,
      validator: validatorMsg != null
          ? (value) {
              if (value == null || value.isEmpty) {
                return validatorMsg;
              }
              return null;
            }
          : null,
    );
  }
}



class ViewFoundItemPage extends StatefulWidget {
  final int itemId;

  const ViewFoundItemPage({super.key, required this.itemId});

  @override
  _ViewFoundItemPageState createState() => _ViewFoundItemPageState();
}

class _ViewFoundItemPageState extends State<ViewFoundItemPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  String? imageUrl;
  bool isLoading = true;

  // This holds all items fetched or submitted to show as cards
  List<Map<String, dynamic>> allItems = [];

  @override
  void initState() {
    super.initState();
    fetchFoundItem(); // fetch the initial item by ID and add to allItems
  }

  Future<void> fetchFoundItem() async {
    final url = Uri.parse('http://127.0.0.1:8000/found-items/${widget.itemId}/');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Add the fetched item to the list if not already present
        if (!allItems.any((item) => item['id'] == data['id'])) {
          allItems.add(data);
        }

        setState(() {
          // Set form fields with this fetched data
          nameController.text = data['name'] ?? '';
          descriptionController.text = data['description'] ?? '';
          locationController.text = data['location'] ?? '';
          dateController.text = data['date_found'] ?? '';
          contactController.text = data['contact_info'] ?? '';
          imageUrl = data['image'];

          isLoading = false;
        });
      } else {
        showError('Failed to fetch item data');
        setState(() => isLoading = false);
      }
    } catch (e) {
      showError('Error: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final url = Uri.parse('http://127.0.0.1:8000/found-items/'); // POST to create new

    try {
      // Parse and format date
      DateTime? parsedDate;
      try {
        parsedDate = DateFormat('yyyy-MM-dd').parseStrict(dateController.text);
      } catch (_) {
        parsedDate = DateTime.tryParse(dateController.text);
      }
      if (parsedDate == null) {
        showError('Invalid date format. Use yyyy-MM-dd');
        return;
      }
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': nameController.text,
          'description': descriptionController.text,
          'location': locationController.text,
          'date_found': formattedDate,
          'contact_info': contactController.text,
        }),
      );

      if (response.statusCode == 201) { // Created
        final newItem = json.decode(response.body);
        setState(() {
          allItems.add(newItem);
          // Clear the form for new entry
          nameController.clear();
          descriptionController.clear();
          locationController.clear();
          dateController.clear();
          contactController.clear();
          imageUrl = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New item created successfully')),
        );
      } else {
        showError('Failed to create new item');
      }
    } catch (e) {
      showError('Error: $e');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    if (dateController.text.isNotEmpty) {
      try {
        initialDate = DateFormat('yyyy-MM-dd').parse(dateController.text);
      } catch (_) {}
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Widget _editableField(TextEditingController controller, String label,
      [TextInputType? keyboardType, void Function()? onTap, bool readOnly = false]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: label == 'Date of Found' ? const Icon(Icons.calendar_today) : null,
      ),
      keyboardType: keyboardType ?? TextInputType.text,
      readOnly: readOnly,
      onTap: onTap,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label cannot be empty';
        }
        return null;
      },
    );
  }

  Widget buildCard(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item['name'] ?? '-', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Description: ${item['description'] ?? '-'}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Location: ${item['location'] ?? '-'}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Date Found: ${item['date_found'] ?? '-'}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Contact Info: ${item['contact_info'] ?? '-'}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            if (item['image'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(item['image'], height: 180),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View Found Item")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Editable form card
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Add New Found Item",
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              _editableField(nameController, 'Name'),
                              const SizedBox(height: 12),
                              _editableField(descriptionController, 'Description'),
                              const SizedBox(height: 12),
                              _editableField(locationController, 'Location'),
                              const SizedBox(height: 12),
                              _editableField(
                                dateController,
                                'Date of Found',
                                TextInputType.datetime,
                                () => _selectDate(context),
                                true,
                              ),
                              const SizedBox(height: 12),
                              _editableField(contactController, 'Contact Info', TextInputType.phone),
                              const SizedBox(height: 20),
                             
                                                            ElevatedButton(
                                onPressed: _submitForm,
                                child: const Text('Submit', style: TextStyle(fontSize: 16)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Display all found item cards
                    Column(
                      children: allItems.map((item) => buildCard(item)).toList(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

