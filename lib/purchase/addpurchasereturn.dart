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
  final greenColor = Colors.green.shade700;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width < 380 ? 16.0 : 20.0;

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
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 16, offset: Offset(0, -6))
            ],
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                horizontalPadding, 20, horizontalPadding, 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Supplier & Basic Info ───────────────────────────────
                _buildCardSection(
                  children: [
                    _buildResponsiveRow([
                      _buildDropdown(
                          'Supplier*',
                          selectedSupplier,
                          [
                            'Please Select',
                            'Vianet Communication Ltd.',
                            'Technovate Intl.',
                            'Escanc Nepal'
                          ],
                          (v) => setState(() => selectedSupplier = v)),
                      _buildTextField('Bill No*', _billNoController,
                          hint: 'Bill number'),
                    ]),
                    const SizedBox(height: 18),
                    _buildResponsiveRow([
                      _buildDatePicker('Purchase Date*', purchaseDate,
                          (d) => setState(() => purchaseDate = d)),
                      _buildTextField('Purchase Date (BS)*', null,
                          hint: purchaseDateBS, readOnly: true),
                    ]),
                    const SizedBox(height: 18),
                    _buildResponsiveRow([
                      _buildDropdown(
                          'Purchase Status*',
                          selectedPurchaseStatus,
                          ['Please Select', 'Received', 'Pending', 'Ordered'],
                          (v) => setState(() => selectedPurchaseStatus = v)),
                      _buildDropdown(
                          'Business Location*',
                          selectedBusinessLocation,
                          ['Beyond Tech Nepal Pvt. Ltd. (BL0001)', 'Branch 2'],
                          (v) => setState(() => selectedBusinessLocation = v)),
                    ], wrapLongText: true),
                    const SizedBox(height: 18),
                    _buildResponsiveRow([
                      _buildDropdown(
                          'Pay term',
                          selectedPayTerm,
                          ['Please Select', 'Cash', 'Credit 30 days'],
                          (v) => setState(() => selectedPayTerm = v)),
                      _buildTextField('Address', _addressController,
                          hint: 'Supplier address'),
                    ]),
                    const SizedBox(height: 24),
                    _buildFileUploadSection(),
                  ],
                ),

                const SizedBox(height: 28),

                // ── Products Section ───────────────────────────────
                _buildCardSection(
                  children: [
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.upload_file, size: 18),
                          label: const Text('Import'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchProductController,
                            decoration: InputDecoration(
                              hintText: 'Search product / SKU / barcode',
                              prefixIcon: const Icon(Icons.search, size: 22),
                              suffixIcon: IconButton(
                                icon:
                                    Icon(Icons.add_circle, color: primaryColor),
                                onPressed: () {},
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 13),
                              filled: true,
                              fillColor: Colors.white, // ← changed to white
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Horizontal Scrollable Table
                    SizedBox(
                      height: 380,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: 880,
                          child: Column(
                            children: [
                              // Header
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: greenColor,
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(10)),
                                ),
                                child: const Row(
                                  children: [
                                    SizedBox(
                                        width: 36,
                                        child: Text('#',
                                            style: _tableHeaderStyle)),
                                    SizedBox(
                                        width: 180,
                                        child: Text('Product',
                                            style: _tableHeaderStyle)),
                                    SizedBox(
                                        width: 60,
                                        child: Text('Qty',
                                            textAlign: TextAlign.center,
                                            style: _tableHeaderStyle)),
                                    SizedBox(
                                        width: 90,
                                        child: Text('Rate',
                                            textAlign: TextAlign.right,
                                            style: _tableHeaderStyle)),
                                    SizedBox(
                                        width: 80,
                                        child: Text('Disc',
                                            textAlign: TextAlign.right,
                                            style: _tableHeaderStyle)),
                                    SizedBox(
                                        width: 70,
                                        child: Text('Tax',
                                            textAlign: TextAlign.right,
                                            style: _tableHeaderStyle)),
                                    SizedBox(
                                        width: 110,
                                        child: Text('Amount',
                                            textAlign: TextAlign.right,
                                            style: _tableHeaderStyle)),
                                    SizedBox(width: 44),
                                  ],
                                ),
                              ),

                              // Rows
                              Expanded(
                                child: cartProducts.isEmpty
                                    ? Center(
                                        child: Text(
                                          'No products added yet',
                                          style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 15),
                                        ),
                                      )
                                    : ListView.builder(
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: cartProducts.length,
                                        itemBuilder: (context, i) =>
                                            _buildCartRow(i, cartProducts[i]),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildTotalLine('Subtotal', subTotal, bold: true),
                          _buildTotalLine('Non-Taxable', nonTaxableAmount,
                              small: true),
                          _buildTotalLine('Taxable', taxableAmount,
                              small: true),
                          _buildTotalLine('VAT', taxAmount, small: true),
                          const Divider(height: 24),
                          _buildTotalLine('Grand Total', grandTotal,
                              bold: true, large: true, color: primaryColor),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // ── Shipping & TDS ───────────────────────────────
                _buildCardSection(
                  children: [
                    const Text('Shipping & Additional Charges',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 20),
                    _buildResponsiveRow([
                      _buildTextField('Additional Shipping', null,
                          hint: additionalShipping.toStringAsFixed(0),
                          keyboardType: TextInputType.number),
                      _buildDropdown(
                          'TDS Type',
                          selectedTdsType,
                          ['Please Select', 'TDS 1.5%', 'TDS 15%'],
                          (v) => setState(() => selectedTdsType = v)),
                    ]),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField('TDS Amount', null,
                              hint: tdsAmount.toStringAsFixed(2),
                              keyboardType: TextInputType.number),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add expense'),
                          style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 44),

                FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Purchase Saved!')),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'Save Purchase',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),

                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardSection({required List<Widget> children}) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: children),
      ),
    );
  }

  Widget _buildResponsiveRow(List<Widget> children,
      {bool wrapLongText = false}) {
    return Wrap(
      spacing: 14,
      runSpacing: 18,
      children: children.map((child) {
        return wrapLongText ? Flexible(child: child) : Expanded(child: child);
      }).toList(),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController? controller, {
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5)),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            filled: true,
            fillColor: Colors.white, // ← white background
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5)),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          items: items
              .map((e) => DropdownMenuItem(
                    value: e,
                    child:
                        Text(e, overflow: TextOverflow.ellipsis, maxLines: 1),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            filled: true,
            fillColor: Colors.white, // ← white background
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(
    String label,
    DateTime initial,
    ValueChanged<DateTime> onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5)),
        const SizedBox(height: 7),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: initial,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) onSelect(picked);
          },
          child: InputDecorator(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              filled: true,
              fillColor: Colors.white, // ← white background
            ),
            child: Text(
              '${initial.day}-${initial.month}-${initial.year}',
              style: const TextStyle(fontSize: 14.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Attach Document',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5)),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.attach_file, color: Colors.white, size: 20),
          label: const Text(
            'Browse File',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            minimumSize: const Size(double.infinity, 46),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Max 5MB  •  pdf, csv, zip, doc, jpeg, png',
          style: TextStyle(fontSize: 12.5, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildCartRow(int index, Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          SizedBox(
              width: 36,
              child:
                  Text('${index + 1}', style: const TextStyle(fontSize: 13.5))),
          SizedBox(
            width: 180,
            child: Text(
              item['name'] ?? 'Unknown Product',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(fontSize: 13.5),
            ),
          ),
          SizedBox(
            width: 60,
            child: TextField(
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero),
              style: const TextStyle(fontSize: 13.5),
            ),
          ),
          SizedBox(
            width: 90,
            child: TextField(
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero),
              style: const TextStyle(fontSize: 13.5),
            ),
          ),
          SizedBox(width: 80, child: _dummyEditableCell()),
          SizedBox(width: 70, child: _dummyEditableCell()),
          SizedBox(
            width: 110,
            child: Text('Rs. 0.00',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 13.5)),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _dummyEditableCell() => TextField(
        textAlign: TextAlign.right,
        decoration: const InputDecoration(
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero),
        style: const TextStyle(fontSize: 13.5),
      );

  Widget _buildTotalLine(
    String label,
    double value, {
    bool bold = false,
    bool small = false,
    bool large = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: small ? 13 : 14.5,
                fontWeight: bold ? FontWeight.w600 : FontWeight.normal),
          ),
          const SizedBox(width: 12),
          Text(
            'Rs ${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: large ? 17 : 14.5,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  static const _tableHeaderStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 13,
  );

  @override
  void dispose() {
    _billNoController.dispose();
    _addressController.dispose();
    _searchProductController.dispose();
    super.dispose();
  }
}
