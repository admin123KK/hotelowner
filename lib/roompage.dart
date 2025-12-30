import 'package:flutter/material.dart';
import 'package:hotelowner/dashboardpage.dart';

class RoomsPage extends StatelessWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB1936B),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB1936B),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Rooms',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        actions: const [SizedBox(width: 48)],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
          children: const [
            RoomListCard(
              imageUrl: 'https://via.placeholder.com/400x200?text=Standard',
              title: 'Standard',
              bedInfo: '1 Queen Bed | 1 Bed',
              description:
                  'A well-designed room offering all basic amenities needed for a comfortable stay.',
              availability: 'Occupied',
              availabilityColor: Colors.red,
              price: 'Rs. 2500',
            ),
            SizedBox(height: 16),
            RoomListCard(
              imageUrl: 'https://via.placeholder.com/400x200?text=Deluxe',
              title: 'Deluxe',
              bedInfo: '1 King Bed | 1 Bed',
              description: 'Spacious room with premium amenities.',
              availability: 'Available',
              availabilityColor: Colors.green,
              price: 'Rs. 2500',
            ),
            // Add more...
          ],
        ),
      ),
    );
  }
}
