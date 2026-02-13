import 'package:flutter/material.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  // Dummy data - replace with real API fetch later
  final List<Map<String, dynamic>> products = [
    {
      'image': 'https://via.placeholder.com/80?text=HDD',
      'product': '1 TB OS HDD',
      'location': 'Beyond Tech Nepal Pvt. Ltd.',
      'purchasePrice': 'Rs. 4,508.70',
      'sellingPrice': 'Rs. 8,722.19',
      'stock': '1.00 Pieces',
      'type': 'Single',
      'category': '',
      'brand': '',
      'tax': 'VAT',
      'sku': '0555',
    },
    {
      'image': 'https://via.placeholder.com/80?text=MC',
      'product': '10/100/1000M MC 1310/1550 20KM SC(A)',
      'location': 'Beyond Tech Nepal Pvt. Ltd.',
      'purchasePrice': 'Rs. 2,599.99',
      'sellingPrice': 'Rs. 2,300.88',
      'stock': '3.00 Pieces',
      'type': 'Single',
      'category': 'Fiber Accessories -- Media Convertor',
      'brand': '',
      'tax': 'VAT',
      'sku': '0056',
    },
    // Add more dummy items as needed...
  ];

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
        title: Row(
          children: [
            const Text(
              'Products',
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
              // Header: "Product List" or any title
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Row(
                  children: [
                    Icon(Icons.inventory, color: primaryColor, size: 32),
                    const SizedBox(width: 12),
                    Text(
                      'Product List',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable product list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                product['image'],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.image_not_supported,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Product Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['product'],
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    product['location'],
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 8),

                                  // Key info row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildInfoItem(
                                          'Purchase', product['purchasePrice']),
                                      _buildInfoItem(
                                          'Selling', product['sellingPrice']),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildInfoItem('Stock', product['stock']),
                                      _buildInfoItem('Type', product['type']),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildInfoItem('Category',
                                          product['category'] ?? '-'),
                                      _buildInfoItem(
                                          'Brand', product['brand'] ?? '-'),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildInfoItem('Tax', product['tax']),
                                      _buildInfoItem('SKU', product['sku']),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Actions Dropdown
                            PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert, color: primaryColor),
                              onSelected: (value) {
                                // TODO: Handle actions
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Selected: $value')),
                                );
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                    value: 'Edit', child: Text('Edit')),
                                const PopupMenuItem(
                                    value: 'Delete', child: Text('Delete')),
                                const PopupMenuItem(
                                    value: 'Labels', child: Text('Labels')),
                                const PopupMenuItem(
                                    value: 'Add/Edit Opening Stock',
                                    child: Text('Add/Edit Opening Stock')),
                                const PopupMenuItem(
                                    value: 'Product History',
                                    child: Text('Product History')),
                                const PopupMenuItem(
                                    value: 'Duplicate Product',
                                    child: Text('Duplicate Product')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to AddProductPage
          // Navigator.push(context, MaterialPageRoute(builder: (_) => const AddProductPage()));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Go to Add New Product')),
          );
        },
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Product', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
