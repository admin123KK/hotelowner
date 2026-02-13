import 'package:flutter/material.dart';

class AddPurchaseReturnPage extends StatefulWidget {
  const AddPurchaseReturnPage({super.key});

  @override
  State<AddPurchaseReturnPage> createState() => _AddPurchaseReturnPageState();
}

class _AddPurchaseReturnPageState extends State<AddPurchaseReturnPage> {
  final _billNoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSearching = false; // for future loading state

  final primaryColor = const Color(0xFF312C51);
  final accentColor = const Color(0xFFF5E6D3);
  final searchButtonColor = const Color(0xFF312C51);

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
          'Purchase Return',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Main Card
                    Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Title
                            Center(
                              child: Text(
                                'Find Purchase for Return',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Bill No Field + Search Button
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _billNoController,
                                    autofocus:
                                        true, // auto focus when page opens
                                    decoration: InputDecoration(
                                      labelText: 'Bill No*',
                                      hintText: 'Enter Bill No',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                      errorStyle: const TextStyle(
                                          color: Colors.redAccent),
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Bill No is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton.icon(
                                  onPressed: _isSearching
                                      ? null
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() => _isSearching = true);

                                            // Simulate API call delay
                                            Future.delayed(
                                                const Duration(seconds: 1), () {
                                              setState(
                                                  () => _isSearching = false);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Searching for Bill: ${_billNoController.text.trim()}',
                                                  ),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                              // TODO: Real API call here
                                            });
                                          }
                                        },
                                  icon: _isSearching
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(Icons.search, size: 20),
                                  label: Text(
                                      _isSearching ? 'Searching...' : 'Search'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: searchButtonColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 3,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Helper text
                            Center(
                              child: Text(
                                'Enter purchase reference number to create return',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
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
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _billNoController.dispose();
    super.dispose();
  }
}
