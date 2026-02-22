import 'package:flutter/material.dart';

class AddPurchasePage extends StatefulWidget {
  const AddPurchasePage({super.key});

  @override
  State<AddPurchasePage> createState() => _AddPurchasePageState();
}

class _AddPurchasePageState extends State<AddPurchasePage> {
  // Form controllers
  final _billNoController = TextEditingController();
  final _supplierController = TextEditingController();
  final _addressController = TextEditingController();
  final _searchProductController = TextEditingController();

  String? selectedSupplier;
  String? selectedPurchaseStatus = 'Please Select';
  String? selectedBusinessLocation = 'Beyond Tech Nepal Pvt. Ltd. (BL0001)';
  String? selectedPayTerm = 'Please Select';
  String? selectedTdsType = 'Please Select';

  DateTime purchaseDate = DateTime.now();
  String purchaseDateBS = '2082-11-04';

  double subTotal = 0.0;
  double nonTaxableAmount = 0.0;
  double taxableAmount = 0.0;
  double taxAmount = 0.0;
  double grandTotal = 0.0;
  double additionalShipping = 0.0;
  double tdsAmount = 0.0;

  // Dummy products in cart (you can add real ones)
  final List<Map<String, dynamic>> cartProducts = [];

  final primaryColor = const Color(0xFF312C51);
  final accentColor = const Color(0xFFF5E6D3);

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
              'Add Purchase',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First Section: Supplier, Bill No, Dates, Status, Location, Pay Term
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildDropdown(
                                  'Supplier*',
                                  selectedSupplier,
                                  [
                                    'Please Select',
                                    'Vianet Communication Ltd.',
                                    'Technovate Intl.',
                                    'Escanc Nepal'
                                  ],
                                  (val) =>
                                      setState(() => selectedSupplier = val),
                                  true),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                  'Bill No:*', _billNoController, 'Bill No'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDatePicker(
                                  'Purchase Date:*',
                                  purchaseDate,
                                  (date) =>
                                      setState(() => purchaseDate = date)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                  'Purchase Date BS:*',
                                  TextEditingController(text: purchaseDateBS),
                                  '2082-11-04',
                                  readOnly: true),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown(
                                  'Purchase Status:*',
                                  selectedPurchaseStatus,
                                  [
                                    'Please Select',
                                    'Received',
                                    'Pending',
                                    'Ordered'
                                  ],
                                  (val) => setState(
                                      () => selectedPurchaseStatus = val),
                                  true),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDropdown(
                                  'Business Location:*',
                                  selectedBusinessLocation,
                                  [
                                    'Beyond Tech Nepal Pvt. Ltd. (BL0001)',
                                    'Branch 2'
                                  ],
                                  (val) => setState(
                                      () => selectedBusinessLocation = val),
                                  true),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown(
                                  'Pay term:',
                                  selectedPayTerm,
                                  ['Please Select', 'Cash', 'Credit 30 days'],
                                  (val) =>
                                      setState(() => selectedPayTerm = val)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                  'Address:', _addressController, 'Address'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Attach Document:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      // TODO: File picker
                                    },
                                    icon: const Icon(
                                      Icons.attach_file,
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
                                  const Text(
                                      'Max File size: 5MB\nAllowed File: .pdf, .csv, .zip, .doc, .docx, .jpeg, .jpg, .png',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Import Products Section
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Import products
                              },
                              icon: const Icon(Icons.upload_file),
                              label: const Text('Import Products'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: _searchProductController,
                                decoration: InputDecoration(
                                  hintText:
                                      'Enter Product name / SKU / Scan bar code',
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.add_circle,
                                        color: Colors.blue),
                                    onPressed: () {
                                      // TODO: Add new product dialog
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Cart Table Header
                        Container(
                          color: Colors.green.shade700,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          child: const Row(
                            children: [
                              SizedBox(
                                  width: 40,
                                  child: Text('#',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                  flex: 4,
                                  child: Text('Product Name',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                  flex: 1,
                                  child: Text('Qty',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                  flex: 2,
                                  child: Text('Rate',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                  flex: 2,
                                  child: Text('Discount',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                  flex: 2,
                                  child: Text('Tax',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                  flex: 2,
                                  child: Text('Amount',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))),
                              SizedBox(width: 40),
                            ],
                          ),
                        ),

                        // Cart Items (empty for now)
                        SizedBox(
                          height: 200,
                          child: cartProducts.isEmpty
                              ? Center(
                                  child: Text('No products added yet',
                                      style: TextStyle(
                                          color: Colors.grey.shade600)),
                                )
                              : ListView.builder(
                                  itemCount: cartProducts.length,
                                  itemBuilder: (context, index) {
                                    final item = cartProducts[index];
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color:
                                                      Colors.grey.shade300))),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                              width: 40,
                                              child: Text('${index + 1}')),
                                          Expanded(
                                              flex: 4,
                                              child: Text(item['name'])),
                                          Expanded(
                                              flex: 1,
                                              child: TextField(
                                                  decoration:
                                                      const InputDecoration(
                                                          border: InputBorder
                                                              .none),
                                                  textAlign: TextAlign.center,
                                                  controller:
                                                      TextEditingController(
                                                          text: item['qty']
                                                              .toString()))),
                                          Expanded(
                                              flex: 2,
                                              child: TextField(
                                                  decoration:
                                                      const InputDecoration(
                                                          border: InputBorder
                                                              .none),
                                                  textAlign: TextAlign.right,
                                                  controller:
                                                      TextEditingController(
                                                          text: item['price']
                                                              .toStringAsFixed(
                                                                  2)))),
                                          const Expanded(
                                              flex: 2,
                                              child: TextField(
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              InputBorder.none),
                                                  textAlign: TextAlign.right)),
                                          const Expanded(
                                              flex: 2,
                                              child: TextField(
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              InputBorder.none),
                                                  textAlign: TextAlign.right)),
                                          Expanded(
                                              flex: 2,
                                              child: Text(
                                                  'Rs. ${(item['qty'] * item['price']).toStringAsFixed(2)}',
                                                  textAlign: TextAlign.right)),
                                          IconButton(
                                              icon: const Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.red),
                                              onPressed: () {}),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),

                        const SizedBox(height: 16),

                        // Summary
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    'Subtotal: Rs ${subTotal.toStringAsFixed(2)}'),
                                Text(
                                    'Non-Taxable Amount: Rs ${nonTaxableAmount.toStringAsFixed(2)}'),
                                Text(
                                    'Taxable Amount: Rs ${taxableAmount.toStringAsFixed(2)}'),
                                Text('VAT: Rs ${taxAmount.toStringAsFixed(2)}'),
                                Text(
                                    'Grand Total: Rs ${grandTotal.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Color(0xFFB1936B))),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Shipping Details & TDS
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Shipping Details:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                  'Additional Shipping charges:',
                                  TextEditingController(
                                      text: additionalShipping
                                          .toStringAsFixed(0)),
                                  '0',
                                  keyboardType: TextInputType.number),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDropdown(
                                  'TDS Type:',
                                  selectedTdsType,
                                  ['Please Select', 'TDS 1.5%', 'TDS 15%'],
                                  (val) =>
                                      setState(() => selectedTdsType = val)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                  'TDS Amount:',
                                  TextEditingController(
                                      text: tdsAmount.toStringAsFixed(2)),
                                  '0.00',
                                  keyboardType: TextInputType.number),
                            ),
                            const Spacer(),
                            ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Add additional expenses
                              },
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Add additional expenses'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Save Button (example)
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Save purchase logic
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Purchase Saved!')));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Save Purchase',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hint,
      {TextInputType keyboardType = TextInputType.text,
      bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items,
      ValueChanged<String?> onChanged,
      [bool isRequired = false]) {
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime initialDate,
      ValueChanged<DateTime> onDateSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              onDateSelected(picked);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            child: Text(
                '${initialDate.day}-${initialDate.month}-${initialDate.year}'),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Dispose controllers if you add more
    super.dispose();
  }
}
