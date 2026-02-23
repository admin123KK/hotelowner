import 'package:flutter/material.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final primaryColor = const Color(0xFF312C51);
  final accentColor = const Color(0xFFF5E6D3);

  final List<Map<String, dynamic>> products = [
    {
      'image': 'https://via.placeholder.com/80?text=HDD',
      'product': '1 TB OS HDD',
      'sku': '0555',
      'location': 'Beyond Tech Nepal Pvt. Ltd.',
      'purchasePrice': '4,508.70',
      'sellingPrice': '8,722.19',
      'stock': '1.00',
      'unit': 'Pieces',
      'type': 'Single',
      'category': '',
      'brand': '',
      'tax': 'VAT',
    },
    {
      'image': 'https://via.placeholder.com/80?text=MC',
      'product': '10/100/1000M MC 1310/1550 20KM SC(A)',
      'sku': '0056',
      'location': 'Beyond Tech Nepal Pvt. Ltd.',
      'purchasePrice': '2,599.99',
      'sellingPrice': '2,300.88',
      'stock': '3.00',
      'unit': 'Pieces',
      'type': 'Single',
      'category': 'Fiber Accessories -- Media Convertor',
      'brand': '',
      'tax': 'VAT',
    },
  ];

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
        title: const Text(
          'Products',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 16,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  children: [
                    Icon(Icons.inventory_2_rounded,
                        color: primaryColor, size: 30),
                    const SizedBox(width: 12),
                    Text(
                      'Product List',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.filter_list_rounded,
                          color: Colors.grey),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final p = products[index];
                    final stockQty = double.tryParse(p['stock'] ?? '0') ?? 0;
                    final lowStock = stockQty > 0 && stockQty <= 5;

                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  p['image'],
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 72,
                                    height: 72,
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.image_not_supported,
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                p['product'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.2,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                "SKU: ${p['sku']}",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (lowStock)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              'Low Stock',
                                              style: TextStyle(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.orange.shade900,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),

                                    const SizedBox(height: 12),

                                    // Price & Stock row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Purchase",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600]),
                                            ),
                                            Text(
                                              "Rs ${p['purchasePrice']}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Selling",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600]),
                                            ),
                                            Text(
                                              "Rs ${p['sellingPrice']}",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 10),

                                    // Tags / info chips
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        _buildChip(
                                            "${p['stock']} ${p['unit']}",
                                            lowStock
                                                ? Colors.orange
                                                : Colors.teal),
                                        _buildChip(
                                            p['type'], Colors.indigo.shade300),
                                        if (p['tax'].isNotEmpty)
                                          _buildChip(
                                              p['tax'], Colors.purple.shade300),
                                        if (p['category'].isNotEmpty)
                                          _buildChip(
                                            p['category'].length > 22
                                                ? '${p['category'].substring(0, 19)}...'
                                                : p['category'],
                                            Colors.blueGrey.shade400,
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // More actions
                              PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert_rounded,
                                    color: primaryColor.withOpacity(0.8)),
                                onSelected: (value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Action: $value')),
                                  );
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                      value: 'Edit', child: Text('Edit')),
                                  const PopupMenuItem(
                                      value: 'Delete', child: Text('Delete')),
                                  const PopupMenuItem(
                                      value: 'Stock',
                                      child: Text('Add/Edit Stock')),
                                  const PopupMenuItem(
                                      value: 'History',
                                      child: Text('Product History')),
                                  const PopupMenuItem(
                                      value: 'Labels',
                                      child: Text('Print Labels')),
                                ],
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigator.push(context, MaterialPageRoute(builder: (_) => const AddProductPage()));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Navigate to Add Product')),
          );
        },
        backgroundColor: primaryColor,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add Product', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color.withOpacity(0.9),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
