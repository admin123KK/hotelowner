import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hotelowner/api.dart';
import 'package:hotelowner/bookingpage.dart';
import 'package:hotelowner/loginpage.dart';
import 'package:http/http.dart' as http;

// Global token variable (saved in memory after login)
String? authToken;

class MainDashboardPage extends StatefulWidget {
  const MainDashboardPage({super.key});

  @override
  State<MainDashboardPage> createState() => _MainDashboardPageState();
}

class _MainDashboardPageState extends State<MainDashboardPage> {
  Widget _currentPage = const DashboardHome();

  void _onMenuItemSelected(Widget newPage) {
    setState(() {
      _currentPage = newPage;
    });
    Navigator.pop(context);
  }

  // Show confirmation dialog before logout
  Future<void> _showLogoutConfirmation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            TextButton(
              child: const Text('OK',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _performLogout(); // Proceed with logout
              },
            ),
          ],
        );
      },
    );
  }

  // Real Logout with Bearer Token
  Future<void> _performLogout() async {
    if (authToken == null) {
      _navigateToLogin();
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.logoutEndPoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({}),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          (data['success'] == true || data['success'] == 'true')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logout successful!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Logged out from device'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out from device (offline)'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      authToken = null;
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Loginpage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentPage.runtimeType == DashboardHome
          ? AppBar(
              backgroundColor: const Color(0xFFB1936B),
              elevation: 0,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              actions: const [SizedBox(width: 48)],
            )
          : null,
      drawer: _currentPage.runtimeType == DashboardHome ? _buildDrawer() : null,
      backgroundColor: const Color(0xFFB1936B),
      body: _currentPage,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 220,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFB1936B),
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child:
                        Icon(Icons.person, size: 50, color: Color(0xFFB1936B)),
                  ),
                  const SizedBox(height: 16),
                  const Text('Hotel Owner',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const Text('owner@gmail.com',
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            _buildDrawerItem(
                Icons.dashboard, 'Dashboard', const DashboardHome()),
            _buildDrawerItem(Icons.hotel, 'Rooms', const RoomsPage()),
            _buildDrawerItem(
                Icons.receipt_long, 'Transactions', const TransactionsPage()),
            _buildDrawerItem(Icons.bar_chart, 'Stats', const StatsPage()),
            _buildDrawerItem(Icons.settings, 'Setting', const SettingsPage()),
            _buildDrawerItem(Icons.book_online_outlined, 'Booking Detail',
                const BookingPage()),
            const Divider(height: 40, thickness: 1),
            _buildDrawerItem(Icons.logout, 'Logout', null, isLogout: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, Widget? page,
      {bool isLogout = false}) {
    bool isSelected = _currentPage.runtimeType == page?.runtimeType;

    return ListTile(
      leading: Icon(icon,
          color: isSelected ? const Color(0xFFB1936B) : Colors.grey.shade700),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? const Color(0xFFB1936B) : Colors.black87,
        ),
      ),
      selected: isSelected,
      selectedTileColor: const Color(0xFFFFF3E8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        if (isLogout) {
          _showLogoutConfirmation(); // Show alert dialog first
        } else if (page != null) {
          _onMenuItemSelected(page);
        }
      },
    );
  }
}

// ===================== DASHBOARD HOME (unchanged) =====================
class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dashboard',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const SizedBox(height: 30),

            // Reservation Details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF5),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Reservation Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(Icons.calendar_today, '20', 'Booking'),
                      _buildStatItem(Icons.input, '20', 'Check-in'),
                      _buildStatItem(Icons.output, '20', 'Check-out'),
                      _buildStatItem(Icons.refresh, '20', 'Start Now'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Available Rooms
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF5),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Available Rooms',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(Icons.hotel, '20', 'Rooms'),
                      _buildStatItem(
                          Icons.calendar_today, '20', 'Availability'),
                      _buildStatItem(Icons.bed, '20', 'Occupied'),
                      _buildStatItem(Icons.build, '20', 'Not-Ready'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Reservations',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: const Color(0xFFF5E6D3),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Row(children: [
                    Text('Last 7 Days ', style: TextStyle(fontSize: 14)),
                    Icon(Icons.arrow_drop_down, size: 18),
                  ]),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF5),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildLegendItem(const Color(0xFFD4B896), 'Booked'),
                      const SizedBox(width: 24),
                      _buildLegendItem(Colors.grey.shade500, 'Canceled'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildStackedBar(60, 25),
                      _buildStackedBar(85, 15),
                      _buildStackedBar(70, 20),
                      _buildStackedBar(55, 20),
                      _buildStackedBar(45, 15),
                      _buildStackedBar(90, 10),
                      _buildStackedBar(70, 20),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Text('Dec 27',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('1 Jan',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('2 Jan',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('3 Jan',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('4 Jan',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('5 Jan',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('6 Jan',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Transactions',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () {},
                    child: const Text('Show All',
                        style: TextStyle(color: Colors.brown))),
              ],
            ),
            const SizedBox(height: 16),
            _buildTransactionItem('Susant', 'Room 107 • 2 Feb-5 Feb'),
            _buildTransactionItem('Sanchar', 'Room 25 • 5 Feb-10 Feb'),
            _buildTransactionItem('David', 'Room 10 • 3 Feb-7 Feb'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String count, String label) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.brown.shade700),
        const SizedBox(height: 8),
        Text(count,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(children: [
      Container(width: 16, height: 16, color: color),
      const SizedBox(width: 8),
      Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87)),
    ]);
  }

  Widget _buildStackedBar(double bookedHeight, double canceledHeight) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 36,
            height: bookedHeight,
            decoration: const BoxDecoration(
                color: Color(0xFFD4B896),
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)))),
        Container(
            width: 36,
            height: canceledHeight,
            decoration: BoxDecoration(
                color: Colors.grey.shade500,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(8)))),
      ],
    );
  }

  Widget _buildTransactionItem(String name, String details) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
              radius: 26,
              backgroundColor: Colors.grey.shade200,
              child: Text(name[0],
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54))),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(details,
                    style:
                        TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        ],
      ),
    );
  }
}

// ===================== ROOMS PAGE - WITH RoomListCard =====================
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
              description:
                  'Spacious room with premium amenities and elegant furnishing.',
              availability: 'Available',
              availabilityColor: Colors.green,
              price: 'Rs. 2500',
            ),
          ],
        ),
      ),
    );
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
      height: 220,
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(20)),
            child: Image.network(
              imageUrl,
              width: 140,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 140,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported,
                      size: 50, color: Colors.grey),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(bedInfo,
                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  Text(
                    description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, height: 1.4),
                  ),
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
                      Text(price,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholders
class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Transactions')));
}

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Stats')));
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Settings')));
}
