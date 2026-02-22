import 'package:flutter/material.dart';

class AddPurchasePage extends StatefulWidget {
  const AddPurchasePage({super.key});

  @override
  State<AddPurchasePage> createState() => _AddPurchasePageState();
}

class _AddPurchasePageState extends State<AddPurchasePage> {
  final _billNoController = TextEditingController();
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

  final List<Map<String, dynamic>> cartProducts = [];

  final primaryColor = const Color(0xFF312C51);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    final double padding = isSmallScreen ? 12.0 : 16.0;
    final double spacing = isSmallScreen ? 12.0 : 16.0;
    final double fontSize = isSmallScreen ? 14.0 : 16.0;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Purchase',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
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
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      children: [
                        Row(
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
                                (val) => setState(() => selectedSupplier = val),
                              ),
                            ),
                            SizedBox(width: spacing),
                            Expanded(
                              child: _buildTextField(
                                'Bill No:*',
                                _billNoController,
                                'Bill No',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDatePicker(
                                  'Purchase Date:*',
                                  purchaseDate,
                                  (date) => setState(() => purchaseDate = date),
                                  fontSize),
                            ),
                            SizedBox(width: spacing),
                            Expanded(
                              child: _buildTextField(
                                  'Purchase Date BS:*',
                                  TextEditingController(text: purchaseDateBS),
                                  '2082-11-04',
                                  readOnly: true),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing),
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
                              ),
                            ),
                            SizedBox(width: spacing),
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
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown(
                                'Pay term:',
                                selectedPayTerm,
                                ['Please Select', 'Cash', 'Credit 30 days'],
                                (val) => setState(() => selectedPayTerm = val),
                                fontSize: fontSize,
                              ),
                            ),
                            SizedBox(width: spacing),
                            Expanded(
                              child: _buildTextField(
                                'Address:',
                                _addressController,
                                'Address',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Attach Document:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize)),
                            SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.attach_file,
                                  color: Colors.white),
                              label: const Text('Browse',
                                  style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Max File size: 5MB\nAllowed File: .pdf, .csv, .zip, .doc, .docx, .jpeg, .jpg, .png',
                              style: TextStyle(
                                  fontSize: fontSize - 2, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: spacing),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.upload_file),
                              label: const Text('Import Products'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white),
                            ),
                            SizedBox(width: spacing),
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
                                    onPressed: () {},
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing),
                        Container(
                          color: Colors.green.shade700,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 12),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: 30,
                                  child: Text('#',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSize - 2))),
                              Expanded(
                                  flex: 4,
                                  child: Text('Product Name',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSize - 2))),
                              Expanded(
                                  flex: 1,
                                  child: Text('Qty',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSize - 2))),
                              Expanded(
                                  flex: 2,
                                  child: Text('Rate',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSize - 2))),
                              Expanded(
                                  flex: 2,
                                  child: Text('Discount',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSize - 2))),
                              Expanded(
                                  flex: 2,
                                  child: Text('Tax',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSize - 2))),
                              Expanded(
                                  flex: 2,
                                  child: Text('Amount',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSize - 2))),
                              const SizedBox(width: 30),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: cartProducts.isEmpty
                              ? Center(
                                  child: Text('No products added yet',
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: fontSize - 2)))
                              : ListView.builder(
                                  itemCount: cartProducts.length,
                                  itemBuilder: (context, index) {
                                    final item = cartProducts[index];
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 12),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color:
                                                      Colors.grey.shade300))),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                              width: 30,
                                              child: Text('${index + 1}',
                                                  style: TextStyle(
                                                      fontSize: fontSize - 2))),
                                          Expanded(
                                              flex: 4,
                                              child: Text(
                                                  item['name'] ?? 'Product',
                                                  style: TextStyle(
                                                      fontSize: fontSize - 2))),
                                          Expanded(
                                              flex: 1,
                                              child: TextField(
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              InputBorder.none),
                                                  textAlign: TextAlign.center,
                                                  controller:
                                                      TextEditingController(
                                                          text: '1'),
                                                  style: TextStyle(
                                                      fontSize: fontSize - 2))),
                                          Expanded(
                                              flex: 2,
                                              child: TextField(
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              InputBorder.none),
                                                  textAlign: TextAlign.right,
                                                  controller:
                                                      TextEditingController(
                                                          text: '0.00'),
                                                  style: TextStyle(
                                                      fontSize: fontSize - 2))),
                                          Expanded(
                                              flex: 2,
                                              child: TextField(
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              InputBorder.none),
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      fontSize: fontSize - 2))),
                                          Expanded(
                                              flex: 2,
                                              child: TextField(
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              InputBorder.none),
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      fontSize: fontSize - 2))),
                                          Expanded(
                                              flex: 2,
                                              child: Text('Rs. 0.00',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      fontSize: fontSize - 2))),
                                          IconButton(
                                              icon: const Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.red,
                                                  size: 20),
                                              onPressed: () {}),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                        SizedBox(height: spacing),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    'Subtotal: Rs ${subTotal.toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: fontSize)),
                                Text(
                                    'Non-Taxable Amount: Rs ${nonTaxableAmount.toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: fontSize - 2)),
                                Text(
                                    'Taxable Amount: Rs ${taxableAmount.toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: fontSize - 2)),
                                Text('VAT: Rs ${taxAmount.toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: fontSize - 2)),
                                Text(
                                    'Grand Total: Rs ${grandTotal.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: fontSize + 2,
                                        color: primaryColor)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: spacing),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Shipping Details:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize + 2)),
                        SizedBox(height: spacing),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                'Additional Shipping charges:',
                                TextEditingController(
                                    text:
                                        additionalShipping.toStringAsFixed(0)),
                                '0',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(width: spacing),
                            Expanded(
                              child: _buildDropdown(
                                'TDS Type:',
                                selectedTdsType,
                                ['Please Select', 'TDS 1.5%', 'TDS 15%'],
                                (val) => setState(() => selectedTdsType = val),
                                fontSize: fontSize,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacing),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                'TDS Amount:',
                                TextEditingController(
                                    text: tdsAmount.toStringAsFixed(2)),
                                '0.00',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton.icon(
                              onPressed: () {},
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
                SizedBox(height: spacing * 2),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Purchase Saved!')));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.35, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Save Purchase',
                        style: TextStyle(
                            fontSize: fontSize + 2, color: Colors.white)),
                  ),
                ),
                SizedBox(height: spacing * 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    double fontSize = 16.0,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          style: TextStyle(fontSize: fontSize - 1),
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged, {
    bool isRequired = false,
    double fontSize = 16.0,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
        SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: TextStyle(fontSize: fontSize - 1))))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime initialDate,
      ValueChanged<DateTime> onDateSelected, double fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
        SizedBox(height: 6),
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
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            child: Text(
              '${initialDate.day}-${initialDate.month}-${initialDate.year}',
              style: TextStyle(fontSize: fontSize - 1),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _billNoController.dispose();
    _addressController.dispose();
    _searchProductController.dispose();
    super.dispose();
  }
}
