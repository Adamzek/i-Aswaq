import 'dart:io'; 
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 

class AddItemPage extends StatefulWidget {
  const AddItemPage({Key? key}) : super(key: key);

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0; 

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  
  String _selectedCondition = "Used"; 
  String _selectedCategory = "";
  
  List<XFile> _selectedImages = []; 
  final ImagePicker _picker = ImagePicker();

  final Color kGoldColor = const Color(0xFFD4AF37);
  final Color kGreyBackground = const Color(0xFFF5F5F5);
  final List<String> _categories = [
    "Electronics", "Books", "Clothing", "Furniture", "Sports", "Stationery", "Others"
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_selectedImages.length >= 5) return;

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        setState(() {
          _selectedImages.add(image);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to pick image")),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      print("Publishing Item: ${_titleController.text}");
      Navigator.pop(context); 
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _prevStep,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create Listing",
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              "Step ${_currentStep + 1} of 3",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildProgressSegment(0),
                const SizedBox(width: 8),
                _buildProgressSegment(1),
                const SizedBox(width: 8),
                _buildProgressSegment(2),
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), 
        children: [
          _buildStep1Photos(),
          _buildStep2Details(),
          _buildStep3Review(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -5),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGoldColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  _currentStep == 2 ? "Publish Listing" : "Continue",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            if (_currentStep == 2) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Save as Draft",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSegment(int stepIndex) {
    bool isActive = _currentStep >= stepIndex;
    return Expanded(
      child: Container(
        height: 4,
        decoration: BoxDecoration(
          color: isActive ? kGoldColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildImageDisplay(XFile file) {
    if (kIsWeb) {
      return Image.network(
        file.path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      return Image.file(
        File(file.path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
  }

  Widget _buildStep1Photos() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Add Photos",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Add up to 5 photos. The first photo will be the cover.",
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              ...List.generate(_selectedImages.length, (index) {
                return Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: _buildImageDisplay(_selectedImages[index]),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle
                          ),
                          child: const Icon(Icons.close, size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                    if (index == 0)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: kGoldColor,
                              borderRadius: BorderRadius.circular(4)),
                          child: const Text("Cover",
                              style: TextStyle(fontSize: 10, color: Colors.white)),
                        ),
                      )
                  ],
                );
              }),
              if (_selectedImages.length < 5)
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: kGoldColor, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined, color: kGoldColor),
                        const SizedBox(height: 4),
                        Text("Add Photo",
                            style: TextStyle(color: kGoldColor, fontSize: 12))
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep2Details() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("Title"),
          _buildTextField(
            controller: _titleController, 
            hint: "Item Name (e.g. MacBook Pro)"
          ),
          
          _buildLabel("Description"),
          _buildTextField(
            controller: _descController, 
            hint: "Describe your item...", 
            maxLines: 4
          ),

          _buildLabel("Category"),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _categories.map((cat) {
              final isSelected = _selectedCategory == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                selectedColor: kGoldColor,
                backgroundColor: kGreyBackground,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                ),
                onSelected: (bool selected) {
                  setState(() {
                    _selectedCategory = selected ? cat : "";
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          _buildLabel("Condition"),
          Row(
            children: [
              Expanded(child: _buildConditionButton("New")),
              const SizedBox(width: 16),
              Expanded(child: _buildConditionButton("Used")),
            ],
          ),
          const SizedBox(height: 24),

          _buildLabel("Price (RM)"),
          _buildTextField(
            controller: _priceController, 
            hint: "0.00", 
            isNumber: true
          ),
        ],
      ),
    );
  }

  Widget _buildStep3Review() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Review Your Listing",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                 BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 5))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: _selectedImages.isEmpty 
                      ? const Center(child: Icon(Icons.image, size: 50, color: Colors.grey))
                      : _buildImageDisplay(_selectedImages[0]), 
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _titleController.text.isEmpty ? "No Title" : _titleController.text,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "RM ${_priceController.text}",
                        style: TextStyle(fontSize: 24, color: kGoldColor, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildTag(_selectedCondition),
                          const SizedBox(width: 8),
                          if (_selectedCategory.isNotEmpty)
                             _buildTag(_selectedCategory),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          
          const SizedBox(height: 30),
          
          _buildEditOption("Edit Photos", () {
            _pageController.jumpToPage(0);
            setState(() => _currentStep = 0);
          }, "${_selectedImages.length} photos"),

          _buildEditOption("Edit Details", () {
            _pageController.jumpToPage(1);
            setState(() => _currentStep = 1);
          }, "Change details"),
        ],
      ),
    );
  }
  
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller, 
    required String hint, 
    bool isNumber = false,
    int maxLines = 1
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: kGoldColor),
          ),
        ),
      ),
    );
  }

  Widget _buildConditionButton(String label) {
    bool isSelected = _selectedCondition == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCondition = label),
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? kGoldColor : kGreyBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: kGreyBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(color: Colors.grey, fontSize: 12)),
    );
  }

  Widget _buildEditOption(String title, VoidCallback onTap, String subtext) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: onTap,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(subtext, style: const TextStyle(color: Colors.grey)), 
        tileColor: kGreyBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(Icons.edit, color: kGoldColor, size: 20),
      ),
    );
  }
}
