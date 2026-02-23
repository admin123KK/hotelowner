import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers (unchanged)
  final _productNameController = TextEditingController();
  final _skuController = TextEditingController();
  final _alertQtyController = TextEditingController(text: '0');
  final _hsCodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costExcTaxController = TextEditingController();
  final _costIncTaxController = TextEditingController();
  final _marginController = TextEditingController(text: '25.00');
  final _saleExcTaxController = TextEditingController();

  // Selections (unchanged)
  String? _unit,
      _brand,
      _category,
      _subCategory,
      _barcodeType = 'Code 128 (C128)';
  final List<String> _businessLocations = [
    'Beyond Tech Nepal Pvt. Ltd. (BL0001)'
  ];
  bool _enablePOS = true;
  bool _manageStock = true;
  bool _isService = false;
  bool _isSubscription = false;
  String? _subscriptionInterval = 'Quarterly';
  String? _sellingTaxType = 'Exclusive';
  String? _productType = 'Single';

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
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 20, offset: Offset(0, -8)),
            ],
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Basic Information'),
                  const SizedBox(height: 24),

                  _buildTextField('Product Name*', _productNameController,
                      isRequired: true),
                  const SizedBox(height: 16),
                  _buildTextField('SKU', _skuController),
                  const SizedBox(height: 16),

                  _buildDropdown('Barcode Type*', _barcodeType, barcodeTypes,
                      (v) => setState(() => _barcodeType = v),
                      isRequired: true),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownWithAdd('Unit*', _unit, units,
                            (v) => setState(() => _unit = v),
                            isRequired: true),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDropdownWithAdd('Brand', _brand, brands,
                            (v) => setState(() => _brand = v)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildDropdownWithAdd('Category*', _category, categories,
                      (v) => setState(() => _category = v),
                      isRequired: true),
                  const SizedBox(height: 16),

                  _buildDropdown('Sub category', _subCategory, subCategories,
                      (v) => setState(() => _subCategory = v)),
                  const SizedBox(height: 24),

                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: 180,
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
                      SizedBox(
                        width: 180,
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
                      SizedBox(
                        width: 180,
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
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                          child: _buildTextField(
                              'Alert quantity', _alertQtyController,
                              keyboardType: TextInputType.number)),
                      const SizedBox(width: 16),
                      Expanded(
                          child: _buildTextField('HS Code', _hsCodeController)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _buildTextField('Product Description', _descriptionController,
                      maxLines: 4),
                  const SizedBox(height: 32),

                  // ── Images / Files ───────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Product image',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            _buildUploadButton(Icons.image, 'Browse'),
                            const SizedBox(height: 8),
                            const Text('Max 5MB  •  1:1',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Product brochure',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            _buildUploadButton(
                                Icons.attach_file, 'Choose File'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // ── Pricing Section ───────────────────────────────
                  _buildSectionHeader('Pricing & Subscription'),
                  const SizedBox(height: 24),

                  CheckboxListTile(
                    title: const Text('Is Subscription Product'),
                    value: _isSubscription,
                    onChanged: (v) =>
                        setState(() => _isSubscription = v ?? false),
                    activeColor: primaryColor,
                    contentPadding: EdgeInsets.zero,
                  ),
                  if (_isSubscription) ...[
                    const SizedBox(height: 16),
                    _buildDropdown(
                      'Subscription Interval',
                      _subscriptionInterval,
                      ['Monthly', 'Quarterly', 'Yearly'],
                      (v) => setState(() => _subscriptionInterval = v),
                    ),
                  ],
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                          child: _buildDropdown('Tax Category', null,
                              ['None', 'VAT 13%'], (v) {})),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDropdown(
                          'Selling Price Tax Type*',
                          _sellingTaxType,
                          ['Exclusive', 'Inclusive'],
                          (v) => setState(() => _sellingTaxType = v),
                          isRequired: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _buildDropdown(
                      'Product Type*',
                      _productType,
                      ['Single', 'Variant'],
                      (v) => setState(() => _productType = v),
                      isRequired: true),
                  const SizedBox(height: 32),

                  // Pricing Table ───────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.08),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15)),
                          ),
                          child: const Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Text('Cost Price',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600))),
                              Expanded(
                                  child: Text('Margin (%)',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600))),
                              Expanded(
                                  flex: 2,
                                  child: Text('Sale Price (Exc. Tax)',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600))),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    _buildTextField(
                                        'Exc. Tax*', _costExcTaxController,
                                        keyboardType: TextInputType.number,
                                        isRequired: true),
                                    const SizedBox(height: 16),
                                    _buildTextField(
                                        'Inc. Tax*', _costIncTaxController,
                                        keyboardType: TextInputType.number,
                                        isRequired: true),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                    'Margin (%)', _marginController,
                                    keyboardType: TextInputType.number),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 2,
                                child: _buildTextField(
                                    'Exc. Tax', _saleExcTaxController,
                                    keyboardType: TextInputType.number),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ── Action Buttons ───────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          'Save & Add\nOpening Stock',
                          primaryColor.withOpacity(0.9),
                          () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          'Save & Add\nAnother',
                          primaryColor.withOpacity(0.75),
                          () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          'Save',
                          greenColor,
                          () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Product Saved Successfully!')),
                              );
                            }
                          },
                          isPrimary: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
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
      style: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: isRequired
          ? (v) => v!.trim().isEmpty ? '$label is required' : null
          : null,
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged, {
    bool isRequired = false,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator:
          isRequired ? (v) => v == null ? '$label is required' : null : null,
    );
  }

  Widget _buildDropdownWithAdd(
    String label,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged, {
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Color(0xFF312C51)),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
              onPressed: () {}, // TODO
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildDropdown('', value, items, onChanged, isRequired: isRequired),
      ],
    );
  }

  Widget _buildUploadButton(IconData icon, String text) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 20, color: Colors.white),
      label: Text(text, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed,
      {bool isPrimary = false}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: isPrimary ? 3 : 1,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: isPrimary ? 16 : 14,
          fontWeight: isPrimary ? FontWeight.bold : FontWeight.w600,
          height: 1.3,
        ),
      ),
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
