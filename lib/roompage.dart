// File: roomspage.dart
// UPDATED: Uses correct roomTypesEndPoint format with dynamic start_date & end_date
// Fetches real room types + availability + pricing
// Beautiful modern card UI, supports past/future dates (default: today to tomorrow)
// Uses SharedPreferences for Bearer token

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hotelowner/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  List<dynamic> roomTypes = [];
  bool isLoading = true;
  String errorMessage = '';

  // Default date range: today to tomorrow
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    _fetchRoomTypes();
  }

  Future<void> _fetchRoomTypes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      setState(() {
        isLoading = false;
        errorMessage = 'Not logged in. Please login again.';
      });
      return;
    }

    // Format dates as YYYY-MM-DD
    String start =
        '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
    String end =
        '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';

    // Replace BOTH {{value}} placeholders
    String url = ApiConstants.roomTypesEndPoint
        .replaceFirst('{{value}}', start) // start_date
        .replaceFirst('{{value}}', end); // end_date

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['success'] == true) {
          setState(() {
            roomTypes = jsonData['data'] ?? [];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = jsonData['message'] ?? 'No room types found';
            isLoading = false;
          });
        }
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
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Rooms',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
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
          children: [
            // Show selected date range
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Showing availability: ${startDate.day}/${startDate.month}/${startDate.year} to ${endDate.day}/${endDate.month}/${endDate.year}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),

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
                      : roomTypes.isEmpty
                          ? const Center(
                              child: Text('No room types available',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey)))
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 30),
                              itemCount: roomTypes.length,
                              itemBuilder: (context, index) {
                                final room = roomTypes[index];
                                final String type =
                                    room['type'] ?? 'Unknown Room';
                                final int totalRooms = room['rooms_count'] ?? 0;
                                final availability = room['availability'] ?? {};
                                final int available =
                                    availability['available_rooms'] ?? 0;
                                final int booked =
                                    availability['booked_rooms'] ?? 0;
                                final int maintenance =
                                    availability['under_maintenance_rooms'] ??
                                        0;
                                final double price = double.tryParse(
                                      room['default_pricing']
                                                  ['default_price_per_night']
                                              ?.toString() ??
                                          '0',
                                    ) ??
                                    0.0;

                                String status =
                                    available > 0 ? 'Available' : 'Occupied';
                                Color statusColor =
                                    available > 0 ? Colors.green : Colors.red;

                                return RoomListCard(
                                  imageUrl: _getImageForType(type),
                                  title: type,
                                  bedInfo:
                                      '$totalRooms Rooms • $available Available',
                                  description:
                                      'Booked: $booked | Maintenance: $maintenance',
                                  availability: status,
                                  availabilityColor: statusColor,
                                  price:
                                      'Rs. ${price.toStringAsFixed(0)} / night',
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  // Placeholder image based on room type
  String _getImageForType(String type) {
    type = type.toLowerCase();
    if (type.contains('deluxe'))
      return 'https://via.placeholder.com/400x200?text=Deluxe';
    if (type.contains('standard'))
      return 'https://via.placeholder.com/400x200?text=Standard';
    if (type.contains('special'))
      return 'https://via.placeholder.com/400x200?text=Special';
    return 'https://via.placeholder.com/400x200?text=$type';
  }
}

class RoomListCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String bedInfo;
  final String description;
  final String availability;
  final Color availabilityColor;
  final String price;

  const RoomListCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.bedInfo,
    required this.description,
    required this.availability,
    required this.availabilityColor,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 260,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 140,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported,
                      size: 50, color: Colors.grey),
                );
              },
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  bedInfo,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: availabilityColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        availability,
                        style: TextStyle(
                          color: availabilityColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      price,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
