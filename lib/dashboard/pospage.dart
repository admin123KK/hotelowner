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

  // Quick products (dummy data – replace with API later)
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

  // ────────────────────────────────────────────────
  // Cart Operations – moved here so they are defined before build()
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
      _total += price;
    });
  }

  void _removeFromCart(String name, double price) {
    setState(() {
      final itemIndex = _cart.indexWhere((i) => i['name'] == name);
      if (itemIndex != -1) {
        final item = _cart[itemIndex];
        if ((item['qty'] as int) > 1) {
          item['qty'] = (item['qty'] as int) - 1;
          _total -= price;
        } else {
          _cart.removeAt(itemIndex);
          _total -= price;
        }
      }
    });
  }

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
        title: Row(
          children: [
            const Text(
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
            onPressed: () {
              // TODO: Open previous bills / hold orders
            },
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
          child: Row(
            children: [
              // Left side – Quick products grid
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search product or scan barcode...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 1.1,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _quickProducts.length,
                        itemBuilder: (context, index) {
                          final product = _quickProducts[index];
                          return InkWell(
                            onTap: () =>
                                _addToCart(product['name'], product['price']),
                            borderRadius: BorderRadius.circular(16),
                            child: Card(
                              elevation: 2,
                              color:
                                  (product['color'] as Color).withOpacity(0.15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      product['name'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: product['color'],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rs. ${product['price'].toStringAsFixed(0)}',
                                      style: const TextStyle(fontSize: 14),
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

              // Right side – Cart summary
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
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Cart Summary',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _cart.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.shopping_cart_outlined,
                                        size: 80, color: Colors.grey),
                                    SizedBox(height: 16),
                                    Text('Cart is empty',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.grey)),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount: _cart.length,
                                itemBuilder: (context, index) {
                                  final item = _cart[index];
                                  final sub = (item['qty'] as int) *
                                      (item['price'] as double);
                                  return ListTile(
                                    title: Text(item['name']),
                                    subtitle: Text(
                                        'Rs. ${item['price'].toStringAsFixed(2)} × ${item['qty']}'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              Icons.remove_circle_outline,
                                              color: Colors.red),
                                          onPressed: () => _removeFromCart(
                                              item['name'], item['price']),
                                        ),
                                        Text('${item['qty']}',
                                            style:
                                                const TextStyle(fontSize: 16)),
                                        IconButton(
                                          icon: const Icon(
                                              Icons.add_circle_outline,
                                              color: Colors.green),
                                          onPressed: () => _addToCart(
                                              item['name'], item['price']),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                              'Rs. ${item['price'].toStringAsFixed(2)}',
                                              textAlign: TextAlign.right),
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child: Text(
                                              'Rs. ${sub.toStringAsFixed(2)}',
                                              textAlign: TextAlign.right,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  'Rs. ${_total.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // TODO: Process payment
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                  child: const Text('Pay Now'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _cart.clear();
                                      _total = 0.0;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  child: const Text('Clear Cart'),
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
