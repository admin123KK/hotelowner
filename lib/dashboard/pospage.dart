import 'package:flutter/material.dart';

class PosPage extends StatefulWidget {
  const PosPage({super.key});

  @override
  State<PosPage> createState() => _PosPageState();
}

class _PosPageState extends State<PosPage> {
  // Cart items
  final List<Map<String, dynamic>> _cart = [];

  double itemsCount = 0.0;
  double subTotal = 0.0;
  double nonTaxableAmount = 0.0;
  double taxableAmount = 0.0;
  double taxAmount = 0.0;
  double discount = 0.0;
  double orderTax = 0.0;
  double grandTotal = 0.0;

  // Selected filters
  String selectedCategory = 'All Categories';
  String selectedBrand = 'All Brands';

  // Dummy quick products with category & brand
  final List<Map<String, dynamic>> _allProducts = [
    {
      'name': 'Room Tea',
      'price': 50.0,
      'color': Colors.green,
      'category': 'Beverages',
      'brand': 'Local'
    },
    {
      'name': 'Coffee',
      'price': 80.0,
      'color': Colors.brown,
      'category': 'Beverages',
      'brand': 'Nescafe'
    },
    {
      'name': 'Water 1L',
      'price': 30.0,
      'color': Colors.blue,
      'category': 'Beverages',
      'brand': 'Kinley'
    },
    {
      'name': 'Breakfast',
      'price': 350.0,
      'color': Colors.orange,
      'category': 'Food',
      'brand': 'Hotel'
    },
    {
      'name': 'Lunch Thali',
      'price': 450.0,
      'color': Colors.red,
      'category': 'Food',
      'brand': 'Local'
    },
    {
      'name': 'Dinner Veg',
      'price': 500.0,
      'color': Colors.purple,
      'category': 'Food',
      'brand': 'Veg Delight'
    },
  ];

  // Filtered products (starts with all)
  List<Map<String, dynamic>> _quickProducts = [];

  final primaryColor = const Color(0xFF312C51);
  final accentColor = const Color(0xFFF5E6D3);

  // Categories & Brands (you can expand this list)
  final List<String> categories = [
    'All Categories',
    'Beverages',
    'Food',
    'Snacks',
    'Desserts',
  ];

  final List<String> brands = [
    'All Brands',
    'Local',
    'Nescafe',
    'Kinley',
    'Hotel',
    'Veg Delight',
  ];

  @override
  void initState() {
    super.initState();
    _quickProducts = List.from(_allProducts); // start with all products
  }

  void _filterProducts() {
    setState(() {
      _quickProducts = _allProducts.where((p) {
        final matchCategory = selectedCategory == 'All Categories' ||
            p['category'] == selectedCategory;
        final matchBrand =
            selectedBrand == 'All Brands' || p['brand'] == selectedBrand;
        return matchCategory && matchBrand;
      }).toList();
    });
  }

  // ────────────────────────────────────────────────
  // Cart Operations
  // ────────────────────────────────────────────────
  void _addToCart(String name, double price) {
    setState(() {
      final existing = _cart.firstWhere(
        (item) => item['name'] == name,
        orElse: () => {'name': name, 'price': price, 'qty': 0},
      );

      if (existing['qty'] == 0) {
        _cart.add(existing);
      }

      existing['qty'] = (existing['qty'] as int? ?? 0) + 1;

      _updateTotals();
    });
  }

  void _removeFromCart(String name, double pricePerUnit) {
    setState(() {
      final index = _cart.indexWhere((item) => item['name'] == name);
      if (index != -1) {
        final item = _cart[index];
        if ((item['qty'] as int) > 1) {
          item['qty'] = (item['qty'] as int) - 1;
        } else {
          _cart.removeAt(index);
        }
        _updateTotals();
      }
    });
  }

  void _updateTotals() {
    subTotal = _cart.fold(0.0,
        (sum, item) => sum + (item['price'] as double) * (item['qty'] as int));
    itemsCount = _cart.fold(0.0, (sum, item) => sum + (item['qty'] as int));

    taxableAmount = subTotal;
    nonTaxableAmount = 0.0;
    taxAmount = taxableAmount * 0.13; // 13% VAT example
    grandTotal = subTotal + taxAmount - discount + orderTax;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    final double gridPadding = isSmallScreen ? 12.0 : 16.0;
    final int crossAxisCount = isSmallScreen ? (screenWidth < 400 ? 2 : 3) : 4;
    final double childAspectRatio = isSmallScreen ? 1.0 : 1.1;
    final double fontSizeProduct = isSmallScreen ? 13.0 : 15.0;
    final double fontSizePrice = isSmallScreen ? 12.0 : 14.0;

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
              'POS - Point of Sale',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Category & Brand Chips
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: gridPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Categories
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories.map((cat) {
                          final isSelected = cat == selectedCategory;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(cat,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87)),
                              selected: isSelected,
                              selectedColor: primaryColor,
                              backgroundColor: Colors.grey.shade200,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    selectedCategory = cat;
                                  });
                                  _filterProducts();
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Brands
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: brands.map((brand) {
                          final isSelected = brand == selectedBrand;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(brand,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87)),
                              selected: isSelected,
                              selectedColor: primaryColor,
                              backgroundColor: Colors.grey.shade200,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    selectedBrand = brand;
                                  });
                                  _filterProducts();
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: isSmallScreen
                    ? Column(
                        children: [
                          // Products
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(gridPadding),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText:
                                          'Search product or scan barcode...',
                                      prefixIcon: const Icon(Icons.search),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: isSmallScreen ? 12 : 16),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GridView.builder(
                                    padding: EdgeInsets.all(gridPadding),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      childAspectRatio: childAspectRatio,
                                      crossAxisSpacing: gridPadding,
                                      mainAxisSpacing: gridPadding,
                                    ),
                                    itemCount: _quickProducts.length,
                                    itemBuilder: (context, index) {
                                      final product = _quickProducts[index];
                                      return InkWell(
                                        onTap: () => _addToCart(
                                            product['name'], product['price']),
                                        borderRadius: BorderRadius.circular(16),
                                        child: Card(
                                          elevation: 2,
                                          color: (product['color'] as Color)
                                              .withOpacity(0.15),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  product['name'],
                                                  style: TextStyle(
                                                    fontSize: fontSizeProduct,
                                                    fontWeight: FontWeight.bold,
                                                    color: product['color'],
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  'Rs. ${product['price'].toStringAsFixed(0)}',
                                                  style: TextStyle(
                                                      fontSize: fontSizePrice),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Cart + Summary
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                // borderTop:
                                //     BorderSide(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(gridPadding),
                                    child: Text(
                                      'Cart Summary',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 18 : 20,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: _cart.isEmpty
                                        ? Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                    Icons
                                                        .shopping_cart_outlined,
                                                    size: 60,
                                                    color: Colors.grey),
                                                SizedBox(height: 12),
                                                Text('Cart is empty',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey)),
                                              ],
                                            ),
                                          )
                                        : ListView.builder(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: gridPadding),
                                            itemCount: _cart.length,
                                            itemBuilder: (context, index) {
                                              final item = _cart[index];
                                              final sub = (item['qty'] as int) *
                                                  (item['price'] as double);
                                              return ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: Text(item['name'],
                                                    style: TextStyle(
                                                        fontSize:
                                                            fontSizeProduct)),
                                                subtitle: Text(
                                                    'Rs. ${item['price'].toStringAsFixed(2)} × ${item['qty']}',
                                                    style: TextStyle(
                                                        fontSize:
                                                            fontSizeProduct -
                                                                2)),
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(
                                                          Icons
                                                              .remove_circle_outline,
                                                          color: Colors.red,
                                                          size: 24),
                                                      onPressed: () =>
                                                          _removeFromCart(
                                                              item['name'],
                                                              item['price']),
                                                    ),
                                                    Text('${item['qty']}',
                                                        style: TextStyle(
                                                            fontSize:
                                                                fontSizeProduct)),
                                                    IconButton(
                                                      icon: Icon(
                                                          Icons
                                                              .add_circle_outline,
                                                          color: Colors.green,
                                                          size: 24),
                                                      onPressed: () =>
                                                          _addToCart(
                                                              item['name'],
                                                              item['price']),
                                                    ),
                                                    SizedBox(
                                                        width: 80,
                                                        child: Text(
                                                            'Rs. ${sub.toStringAsFixed(2)}',
                                                            textAlign: TextAlign
                                                                .right)),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                  ),

                                  // Summary Section
                                  Container(
                                    padding: EdgeInsets.all(gridPadding),
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                'Items: ${itemsCount.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize: fontSizeProduct)),
                                            Text(
                                                'Sub Total: Rs ${subTotal.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize: fontSizeProduct)),
                                            Text(
                                                'Total: Rs ${grandTotal.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize: fontSizeProduct,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                'Non-Taxable Amount: Rs ${nonTaxableAmount.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize:
                                                        fontSizeProduct - 2)),
                                            Text(
                                                'Taxable Amount: Rs ${taxableAmount.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize:
                                                        fontSizeProduct - 2)),
                                            Text(
                                                'Tax: Rs ${taxAmount.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize:
                                                        fontSizeProduct - 2)),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                'Discount (-): Rs ${discount.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize:
                                                        fontSizeProduct - 2)),
                                            Text(
                                                'Order Tax(+): Rs ${orderTax.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize:
                                                        fontSizeProduct - 2)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          // Left: Products
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(gridPadding),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText:
                                          'Search product or scan barcode...',
                                      prefixIcon: const Icon(Icons.search),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: isSmallScreen ? 12 : 16),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GridView.builder(
                                    padding: EdgeInsets.all(gridPadding),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      childAspectRatio: childAspectRatio,
                                      crossAxisSpacing: gridPadding,
                                      mainAxisSpacing: gridPadding,
                                    ),
                                    itemCount: _quickProducts.length,
                                    itemBuilder: (context, index) {
                                      final product = _quickProducts[index];
                                      return InkWell(
                                        onTap: () => _addToCart(
                                            product['name'], product['price']),
                                        borderRadius: BorderRadius.circular(16),
                                        child: Card(
                                          elevation: 2,
                                          color: (product['color'] as Color)
                                              .withOpacity(0.15),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  product['name'],
                                                  style: TextStyle(
                                                    fontSize: fontSizeProduct,
                                                    fontWeight: FontWeight.bold,
                                                    color: product['color'],
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  'Rs. ${product['price'].toStringAsFixed(0)}',
                                                  style: TextStyle(
                                                      fontSize: fontSizePrice),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Right: Cart + Summary
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                // borderLeft:
                                //     BorderSide(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(gridPadding),
                                    child: Text(
                                      'Cart Summary',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 18 : 20,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: _cart.isEmpty
                                        ? Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                    Icons
                                                        .shopping_cart_outlined,
                                                    size: 60,
                                                    color: Colors.grey),
                                                SizedBox(height: 12),
                                                Text('Cart is empty',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey)),
                                              ],
                                            ),
                                          )
                                        : ListView.builder(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: gridPadding),
                                            itemCount: _cart.length,
                                            itemBuilder: (context, index) {
                                              final item = _cart[index];
                                              final sub = (item['qty'] as int) *
                                                  (item['price'] as double);
                                              return ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: Text(item['name'],
                                                    style: TextStyle(
                                                        fontSize:
                                                            fontSizeProduct)),
                                                subtitle: Text(
                                                    'Rs. ${item['price'].toStringAsFixed(2)} × ${item['qty']}',
                                                    style: TextStyle(
                                                        fontSize:
                                                            fontSizeProduct -
                                                                2)),
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(
                                                          Icons
                                                              .remove_circle_outline,
                                                          color: Colors.red,
                                                          size: 24),
                                                      onPressed: () =>
                                                          _removeFromCart(
                                                              item['name'],
                                                              item['price']),
                                                    ),
                                                    Text('${item['qty']}',
                                                        style: TextStyle(
                                                            fontSize:
                                                                fontSizeProduct)),
                                                    IconButton(
                                                      icon: Icon(
                                                          Icons
                                                              .add_circle_outline,
                                                          color: Colors.green,
                                                          size: 24),
                                                      onPressed: () =>
                                                          _addToCart(
                                                              item['name'],
                                                              item['price']),
                                                    ),
                                                    SizedBox(
                                                        width: 80,
                                                        child: Text(
                                                            'Rs. ${sub.toStringAsFixed(2)}',
                                                            textAlign: TextAlign
                                                                .right)),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                  ),

                                  // Summary Section
                                  Container(
                                    padding: EdgeInsets.all(gridPadding),
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                'Items: ${itemsCount.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize: fontSizeProduct)),
                                            Text(
                                                'Sub Total: Rs ${subTotal.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize: fontSizeProduct)),
                                            Text(
                                                'Total: Rs ${grandTotal.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize: fontSizeProduct,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                'Non-Taxable Amount: Rs ${nonTaxableAmount.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize:
                                                        fontSizeProduct - 2)),
                                            Text(
                                                'Taxable Amount: Rs ${taxableAmount.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize:
                                                        fontSizeProduct - 2)),
                                            Text(
                                                'Tax: Rs ${taxAmount.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize:
                                                        fontSizeProduct - 2)),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                'Discount (-): Rs ${discount.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize:
                                                        fontSizeProduct - 2)),
                                            Text(
                                                'Order Tax(+): Rs ${orderTax.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize:
                                                        fontSizeProduct - 2)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),

              // Bottom Payment Bar
              Container(
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade900,
                  //   borderTop: BorderSide(color: Colors.grey.shade700, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildBottomButton(
                                  'Draft', Icons.save_alt, Colors.orange),
                              _buildBottomButton(
                                  'Quotation', Icons.description, Colors.blue),
                              _buildBottomButton(
                                  'Suspend', Icons.pause, Colors.purple),
                              _buildBottomButton('Credit Sale',
                                  Icons.credit_card, Colors.teal),
                              _buildBottomButton(
                                  'Card', Icons.credit_score, Colors.indigo),
                              _buildBottomButton('Multiple Pay', Icons.payment,
                                  Colors.deepPurple,
                                  isSelected: true),
                              _buildBottomButton(
                                  'QR Payment', Icons.qr_code, Colors.green),
                              _buildBottomButton(
                                  'Cash', Icons.money, Colors.green.shade700),
                              _buildBottomButton(
                                  'Cancel', Icons.close, Colors.red),
                            ],
                          ),
                        ),
                      ),

                      // Right: Total Payable
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14),
                            ),
                            Text(
                              'Rs ${grandTotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Payable:',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(String label, IconData icon, Color color,
      {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? color : color.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
