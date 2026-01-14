import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hotelowner/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  List<dynamic> transactions = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      setState(() {
        isLoading = false;
        errorMessage = 'Not logged in. Please login again.';
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.latestPaymentEndPoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer $token', // Use saved token from SharedPreferences
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['success'] == true) {
          final List<dynamic> paidList =
              jsonData['data']['sell_transactions']['paid'] ?? [];
          setState(() {
            transactions = paidList;
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = jsonData['message'] ?? 'No transactions found';
            isLoading = false;
          });
        }
      } else if (response.statusCode == 401) {
        setState(() {
          errorMessage = 'Session expired. Please login again.';
          isLoading = false;
        });
        // Clear invalid token
        await prefs.remove('auth_token');
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        });
      } else {
        setState(() {
          errorMessage = 'Server error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Network error. Check your connection.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB1936B),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB1936B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transactions',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: const [SizedBox(width: 48)],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        ),
        child: Column(
          children: [
            const Padding(
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
              child: Row(
                children: const [
                  Icon(Icons.receipt_long, size: 32, color: Colors.black87),
                  SizedBox(width: 12),
                  Text(
                    'All Transactions',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ],
              ),
            ),

            // List
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                      ? Center(
                          child: Text(
                            errorMessage,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : transactions.isEmpty
                          ? const Center(
                              child: Text(
                                'No transactions found',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
                              itemCount: transactions.length,
                              itemBuilder: (context, index) {
                                final transaction = transactions[index];
                                final String customerName =
                                    transaction['customer_name'] ??
                                        'Walk-In Customer';
                                final String invoiceNo =
                                    transaction['invoice_no'] ?? 'N/A';
                                final String date =
                                    transaction['transaction_date'] ?? '';
                                final String amount =
                                    transaction['final_total']?.toString() ??
                                        '0.00';
                                final String status =
                                    (transaction['payment_status'] ?? 'unknown')
                                        .toString()
                                        .capitalize();

                                // Format date
                                String formattedDate = 'Unknown Date';
                                if (date.isNotEmpty) {
                                  try {
                                    final DateTime dt = DateTime.parse(date);
                                    formattedDate =
                                        '${dt.day}/${dt.month}/${dt.year} • ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
                                  } catch (e) {
                                    formattedDate = date;
                                  }
                                }

                                // Status color
                                Color statusColor = Colors.green.shade700;
                                if (status.toLowerCase() == 'due' ||
                                    status.toLowerCase() == 'partial') {
                                  statusColor = Colors.orange.shade700;
                                } else if (status.toLowerCase() == 'pending') {
                                  statusColor = Colors.red.shade700;
                                }

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 15,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Customer Name - Highlighted
                                      Text(
                                        customerName,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      // Invoice & Date
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Invoice: $invoiceNo',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            formattedDate,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),

                                      // Amount & Status
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Rs. $amount',
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              color:
                                                  statusColor.withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Text(
                                              status,
                                              style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold,
                                                color: statusColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
