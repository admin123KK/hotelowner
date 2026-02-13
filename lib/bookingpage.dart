import 'package:flutter/material.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF312C51),
      appBar: AppBar(
        backgroundColor: const Color(0xFF312C51),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Booking',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [SizedBox(width: 48)],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 40, 24, 20),
              child: Text(
                'Booking Summary',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            // Header Row (Eye icon removed → only More icon in Action)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF312C51),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: _HeaderText(
                        'Name',
                      )),
                  Expanded(flex: 3, child: _HeaderText('Room')),
                  Expanded(flex: 3, child: _HeaderText('Duration')),
                  Expanded(flex: 4, child: _HeaderText('Check In/out')),
                  Expanded(flex: 2, child: _HeaderText('Action')),
                ],
              ),
            ),

            // Scrollable List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(21, 20, 24, 40),
                itemCount: 20,
                itemBuilder: (context, index) {
                  // Rotating sample data
                  final names = ['Rani', 'Sushant K.', 'Sanchar', 'Rani'];
                  final rooms = [
                    'Single 13',
                    'Deluxe 22',
                    'Standard 12',
                    'Single 13'
                  ];
                  final statuses = ['Verified', 'Paid', 'Verified', 'Pending'];

                  final name = names[index % names.length];
                  final room = rooms[index % rooms.length];
                  final status = statuses[index % statuses.length];

                  // Color based on status
                  final Color statusColor =
                      (status == 'Verified' || status == 'Paid')
                          ? Colors.green.shade700
                          : Colors.orange.shade700;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Main Row Content
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Serial + Name
                              Expanded(
                                flex: 4,
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.black87),
                                    children: [
                                      TextSpan(
                                        text: '${index + 1}. ',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      TextSpan(text: name),
                                    ],
                                  ),
                                ),
                              ),

                              // Room
                              Expanded(
                                flex: 4,
                                child: Text(
                                  room,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                ),
                              ),

                              // Duration
                              const Expanded(
                                flex: 3,
                                child: Text(
                                  '9 Nights',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                ),
                              ),

                              // Check In/Out
                              const Expanded(
                                flex: 4,
                                child: Text(
                                  '20Dec-29Dec',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Colors.grey),
                                ),
                              ),

                              // Action - Only More Vert Icon (Eye removed)
                              const Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Icon(Icons.more_vert,
                                      size: 24, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),

                          // Status Text at Bottom Right - No Container, Just Colored Text
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
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
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;
  const _HeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }
}
