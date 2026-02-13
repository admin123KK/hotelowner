import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _productNameController = TextEditingController();
  final _skuController = TextEditingController();
  final _alertQtyController = TextEditingController(text: '0');
  final _hsCodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costExcTaxController = TextEditingController();
  final _costIncTaxController = TextEditingController();
  final _marginController = TextEditingController(text: '25.00');
  final _saleExcTaxController = TextEditingController();

  // Selections
  String? _unit,
      _brand,
      _category,
      _subCategory,
      _barcodeType = 'Code 128 (C128)';
  List<String> _businessLocations = ['Beyond Tech Nepal Pvt. Ltd. (BL0001)'];
  bool _enablePOS = true;
  bool _manageStock = true;
  bool _isService = false;
  bool _isSubscription = false;
  String? _subscriptionInterval = 'Quarterly';
  String? _sellingTaxType = 'Exclusive';
  String? _productType = 'Single';

  // Dummy options (replace with API later)
  final units = ['Piece', 'Kg', 'Liter', 'Box'];
  final brands = ['Brand A', 'Brand B'];
  final categories = ['Food', 'Beverage', 'Housekeeping'];
  final subCategories = ['Sub A', 'Sub B'];
  final barcodeTypes = ['Code 128 (C128)', 'EAN-13', 'QR Code'];

  final primaryColor = const Color(0xFF312C51);
  final accentColor = const Color(0xFFF5E6D3);
  final greenColor = Colors.green.shade700;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Text(
              'Add New Product',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        actions: const [SizedBox(width: 56)],
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 20, offset: Offset(0, -5)),
            ],
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Information Section
                  _buildSectionHeader('Basic Information'),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: _buildTextField(
                              'Product Name*', _productNameController,
                              isRequired: true)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField('SKU', _skuController)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                          child: _buildDropdown('Barcode Type*', _barcodeType,
                              barcodeTypes, (v) => _barcodeType = v,
                              isRequired: true)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                          child: _buildDropdownWithAdd(
                              'Unit*', _unit, units, (v) => _unit = v,
                              isRequired: true)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildDropdownWithAdd(
                              'Brand', _brand, brands, (v) => _brand = v)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildDropdownWithAdd('Category*', _category,
                              categories, (v) => _category = v,
                              isRequired: true)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('Enable for POS'),
                          value: _enablePOS,
                          onChanged: (v) =>
                              setState(() => _enablePOS = v ?? false),
                          activeColor: primaryColor,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('Manage Stock'),
                          value: _manageStock,
                          onChanged: (v) =>
                              setState(() => _manageStock = v ?? false),
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
                          onChanged: (v) =>
                              setState(() => _isService = v ?? false),
                          activeColor: primaryColor,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                          child: _buildDropdown('Sub category', _subCategory,
                              subCategories, (v) => _subCategory = v)),
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
                              children: _businessLocations
                                  .map((loc) => Chip(
                                        label: Text(loc,
                                            style:
                                                const TextStyle(fontSize: 12)),
                                        backgroundColor:
                                            primaryColor.withOpacity(0.2),
                                        deleteIcon:
                                            const Icon(Icons.close, size: 16),
                                        onDeleted: () => setState(() =>
                                            _businessLocations.remove(loc)),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                          child: _buildTextField(
                              'Alert quantity', _alertQtyController,
                              keyboardType: TextInputType.number)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildTextField('HS Code', _hsCodeController)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _buildTextField('Product Description', _descriptionController,
                      maxLines: 4),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Product image',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () {}, // TODO: image_picker
                              icon: const Icon(
                                Icons.image,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Browse',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor),
                            ),
                            const SizedBox(height: 4),
                            const Text('Max size 5MB\nAspect ratio 1:1',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      // const SizedBox(width: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Product brochure',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.attach_file,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'Choose File',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // ==========================================
                  // PRICING & SUBSCRIPTION SECTION
                  // ==========================================
                  _buildSectionHeader('Pricing & Subscription'),
                  const SizedBox(height: 16),

                  CheckboxListTile(
                    title: const Text('Is Subscription Product'),
                    value: _isSubscription,
                    onChanged: (v) =>
                        setState(() => _isSubscription = v ?? false),
                    activeColor: primaryColor,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  if (_isSubscription) ...[
                    const SizedBox(height: 8),
                    _buildDropdown(
                        'Subscription Interval',
                        _subscriptionInterval,
                        ['Monthly', 'Quarterly', 'Yearly'],
                        (v) => _subscriptionInterval = v),
                  ],
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                          child: _buildDropdown('Tax Category', null,
                              ['None', 'VAT 13%'], (v) {})),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildDropdown(
                              'Selling Price Tax Type*',
                              _sellingTaxType,
                              ['Exclusive', 'Inclusive'],
                              (v) => _sellingTaxType = v,
                              isRequired: true)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildDropdown('Product Type*', _productType,
                      ['Single', 'Variant'], (v) => _productType = v,
                      isRequired: true),
                  const SizedBox(height: 24),

                  // Pricing Table
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          color: primaryColor.withOpacity(0.1),
                          child: const Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Text('Cost Price',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                  child: Text('Margin(%)',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                  flex: 2,
                                  child: Text('Sale Price',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                  child: Text('Product image',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    _buildTextField(
                                        'Exc.*', _costExcTaxController,
                                        keyboardType: TextInputType.number,
                                        isRequired: true),
                                    const SizedBox(height: 12),
                                    _buildTextField(
                                        'Inc. tax*', _costIncTaxController,
                                        keyboardType: TextInputType.number,
                                        isRequired: true),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: _buildTextField(
                                      'Margin(%)', _marginController,
                                      keyboardType: TextInputType.number)),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: _buildTextField(
                                      'Exc. Tax', _saleExcTaxController,
                                      keyboardType: TextInputType.number)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {}, // TODO: image picker
                                  icon: const Icon(
                                    Icons.image,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Choose',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Center(
                            child: const Text('Save & Add\nOpening Stock',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {}, // TODO: Save & add another
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor.withOpacity(0.9),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Center(
                            child: Text('Save & Add\nAnother',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // TODO: Final save
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Product Saved Successfully!')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: greenColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Save',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF312C51)),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isRequired = false,
      TextInputType keyboardType = TextInputType.text,
      int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: isRequired
          ? (v) => v!.trim().isEmpty ? '$label is required' : null
          : null,
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items,
      ValueChanged<String?> onChanged,
      {bool isRequired = false}) {
    return DropdownButtonFormField<String>(
      value: value,
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        filled: true,
        fillColor: Colors.white,
      ),
      validator:
          isRequired ? (v) => v == null ? '$label is required' : null : null,
    );
  }

  Widget _buildDropdownWithAdd(String label, String? value, List<String> items,
      ValueChanged<String?> onChanged,
      {bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(
                Icons.add_circle,
                color: Color(0xFF312C51),
              ),
              onPressed: () {}, // TODO: Add new item logic
            ),
          ],
        ),
        _buildDropdown('', value, items, onChanged, isRequired: isRequired),
      ],
    );
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _skuController.dispose();
    _alertQtyController.dispose();
    _hsCodeController.dispose();
    _descriptionController.dispose();
    _costExcTaxController.dispose();
    _costIncTaxController.dispose();
    _marginController.dispose();
    _saleExcTaxController.dispose();
    super.dispose();
  }
}
