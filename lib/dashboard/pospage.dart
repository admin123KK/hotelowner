import 'package:flutter/material.dart';

class PosPage extends StatefulWidget {
  const PosPage({super.key});

  @override
  State<PosPage> createState() => _PosPageState();
}

class _PosPageState extends State<PosPage> {
  // Cart items
  final List<Map<String, dynamic>> _cart = [];
  double _total = 0.0;

  // Dummy quick products
  final List<Map<String, dynamic>> _quickProducts = [
    {'name': 'Room Tea', 'price': 50.0, 'color': Colors.green},
    {'name': 'Coffee', 'price': 80.0, 'color': Colors.brown},
    {'name': 'Water 1L', 'price': 30.0, 'color': Colors.blue},
    {'name': 'Breakfast', 'price': 350.0, 'color': Colors.orange},
    {'name': 'Lunch Thali', 'price': 450.0, 'color': Colors.red},
    {'name': 'Dinner Veg', 'price': 500.0, 'color': Colors.purple},
  ];

  final primaryColor = const Color(0xFF312C51);
  final accentColor = const Color(0xFFF5E6D3);

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
      _total += price;
    });
  }

  void _removeFromCart(String name, double price) {
    setState(() {
      final index = _cart.indexWhere((i) => i['name'] == name);
      if (index != -1) {
        final item = _cart[index];
        if ((item['qty'] as int) > 1) {
          item['qty'] = (item['qty'] as int) - 1;
          _total -= price;
        } else {
          _cart.removeAt(index);
          _total -= price;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    // Responsive values
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
        title: const Text(
          'POS - Point of Sale',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
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
          child: isSmallScreen
              ? Column(
                  children: [
                    // Top: Product Grid (takes most space on small screens)
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(gridPadding),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search product or scan barcode...',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
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
                                            overflow: TextOverflow.ellipsis,
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

// Bottom: Cart Summary (full width on small screens)
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          // border: BorderSide(color: Colors.grey.shade300),
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
                                  ? const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.shopping_cart_outlined,
                                              size: 60, color: Colors.grey),
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
                                                  fontSize: fontSizeProduct)),
                                          subtitle: Text(
                                              'Rs. ${item['price'].toStringAsFixed(2)} × ${item['qty']}',
                                              style: TextStyle(
                                                  fontSize:
                                                      fontSizeProduct - 2)),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.remove_circle_outline,
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
                                                icon: const Icon(
                                                    Icons.add_circle_outline,
                                                    color: Colors.green,
                                                    size: 24),
                                                onPressed: () => _addToCart(
                                                    item['name'],
                                                    item['price']),
                                              ),
                                              SizedBox(
                                                  width: 60,
                                                  child: Text(
                                                      'Rs. ${sub.toStringAsFixed(2)}',
                                                      textAlign:
                                                          TextAlign.right)),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                            ),
                            Container(
                              padding: EdgeInsets.all(gridPadding),
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Total:',
                                          style: TextStyle(
                                              fontSize: isSmallScreen ? 18 : 20,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        'Rs. ${_total.toStringAsFixed(2)}',
                                        style: TextStyle(
                                            fontSize: isSmallScreen ? 20 : 22,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green),
                                          child: Text('Pay Now',
                                              style: TextStyle(
                                                  fontSize: fontSizeProduct)),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _cart.clear();
                                              _total = 0.0;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          child: Text('Clear Cart',
                                              style: TextStyle(
                                                  fontSize: fontSizeProduct)),
                                        ),
                                      ),
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
                    // Left: Products (larger on big screens)
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(gridPadding),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search product or scan barcode...',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
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
                                            overflow: TextOverflow.ellipsis,
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

                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          // borderLeft: BorderSide(color: Colors.grey.shade300),
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
                                          Icon(Icons.shopping_cart_outlined,
                                              size: 60, color: Colors.grey),
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
                                                  fontSize: fontSizeProduct)),
                                          subtitle: Text(
                                              'Rs. ${item['price'].toStringAsFixed(2)} × ${item['qty']}',
                                              style: TextStyle(
                                                  fontSize:
                                                      fontSizeProduct - 2)),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                    Icons.remove_circle_outline,
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
                                                    Icons.add_circle_outline,
                                                    color: Colors.green,
                                                    size: 24),
                                                onPressed: () => _addToCart(
                                                    item['name'],
                                                    item['price']),
                                              ),
                                              SizedBox(
                                                  width: 80,
                                                  child: Text(
                                                      'Rs. ${sub.toStringAsFixed(2)}',
                                                      textAlign:
                                                          TextAlign.right)),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                            ),
                            Container(
                              padding: EdgeInsets.all(gridPadding),
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Total:',
                                          style: TextStyle(
                                              fontSize: isSmallScreen ? 18 : 20,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        'Rs. ${_total.toStringAsFixed(2)}',
                                        style: TextStyle(
                                            fontSize: isSmallScreen ? 20 : 22,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green),
                                          child: Text('Pay Now',
                                              style: TextStyle(
                                                  fontSize: fontSizeProduct)),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _cart.clear();
                                              _total = 0.0;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          child: Text('Clear Cart',
                                              style: TextStyle(
                                                  fontSize: fontSizeProduct)),
                                        ),
                                      ),
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
      ),
    );
  }
}
