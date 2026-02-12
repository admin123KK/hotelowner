import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _skuController = TextEditingController();
  final _alertQuantityController = TextEditingController(text: '0');
  final _hsCodeController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Selections
  String? _selectedUnit;
  String? _selectedBrand;
  String? _selectedCategory;
  String? _selectedSubCategory;
  String? _selectedBarcodeType = 'Code 128 (C128)';
  List<String> _selectedLocations = ['Beyond Tech Nepal Pvt. Ltd. (BL0001)'];

  bool _enablePOS = true;
  bool _manageStock = true;
  bool _isService = false;

  // Dummy dropdown options (replace with real API data later)
  final List<String> units = ['Piece', 'Kg', 'Liter', 'Box', 'Set'];
  final List<String> brands = ['Brand A', 'Brand B', 'Brand C'];
  final List<String> categories = [
    'Electronics',
    'Food & Beverage',
    'Housekeeping',
    'Stationery'
  ];
  final List<String> subCategories = ['Sub A', 'Sub B', 'Sub C'];
  final List<String> barcodeTypes = [
    'Code 128 (C128)',
    'EAN-13',
    'QR Code',
    'UPC-A'
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFFB1936B); // your app's gold/brown
    final accentColor = const Color(0xFFF5E6D3); // light beige
    final textColor = Colors.black87;

    return Scaffold(
      backgroundColor: accentColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          'Add New Product',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Product Name, SKU, Barcode Type
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Product Name*',
                      controller: _productNameController,
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      label: 'SKU',
                      controller: _skuController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'Barcode Type*',
                      value: _selectedBarcodeType,
                      items: barcodeTypes,
                      onChanged: (val) =>
                          setState(() => _selectedBarcodeType = val),
                      isRequired: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Row 2: Unit, Brand, Category
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildDropdownWithAdd(
                      label: 'Unit*',
                      value: _selectedUnit,
                      items: units,
                      onChanged: (val) => setState(() => _selectedUnit = val),
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDropdownWithAdd(
                      label: 'Brand',
                      value: _selectedBrand,
                      items: brands,
                      onChanged: (val) => setState(() => _selectedBrand = val),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDropdownWithAdd(
                      label: 'Category*',
                      value: _selectedCategory,
                      items: categories,
                      onChanged: (val) =>
                          setState(() => _selectedCategory = val),
                      isRequired: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Checkboxes
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text('Enable for POS'),
                      value: _enablePOS,
                      onChanged: (val) =>
                          setState(() => _enablePOS = val ?? false),
                      activeColor: primaryColor,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text('Manage Stock'),
                      value: _manageStock,
                      onChanged: (val) =>
                          setState(() => _manageStock = val ?? false),
                      activeColor: primaryColor,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text('Is Service'),
                      value: _isService,
                      onChanged: (val) =>
                          setState(() => _isService = val ?? false),
                      activeColor: primaryColor,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Sub-category & Business Locations
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'Sub category',
                      value: _selectedSubCategory,
                      items: subCategories,
                      onChanged: (val) =>
                          setState(() => _selectedSubCategory = val),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Business Locations',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: _selectedLocations.map((loc) {
                            return Chip(
                              label: Text(loc),
                              backgroundColor: primaryColor.withOpacity(0.15),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () {
                                setState(() => _selectedLocations.remove(loc));
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Alert Quantity, HS Code
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Alert quantity',
                      controller: _alertQuantityController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      label: 'HS Code',
                      controller: _hsCodeController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Description
              _buildTextField(
                label: 'Product Description',
                controller: _descriptionController,
                maxLines: 4,
              ),
              const SizedBox(height: 24),

              // Image & Brochure
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Product image',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Image picker
                          },
                          icon: const Icon(Icons.image),
                          label: const Text('Browse'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                            'Max file size 5MB\nAspect ratio should be 1:1',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Product brochure',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: File picker
                          },
                          icon: const Icon(Icons.attach_file),
                          label: const Text('Choose File'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Submit to API
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Product saved successfully!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save Product',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: isRequired
              ? (value) => value == null || value.trim().isEmpty
                  ? '$label is required'
                  : null
              : null,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: isRequired
              ? (v) => v == null ? '$label is required' : null
              : null,
        ),
      ],
    );
  }

  Widget _buildDropdownWithAdd({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: Text(label,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            IconButton(
              icon: const Icon(Icons.add_circle_outline,
                  color: Color(0xFFB1936B)),
              onPressed: () {
                // TODO: Add new item dialog
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildDropdown(
          label: '',
          value: value,
          items: items,
          onChanged: onChanged,
          isRequired: isRequired,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _skuController.dispose();
    _alertQuantityController.dispose();
    _hsCodeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
