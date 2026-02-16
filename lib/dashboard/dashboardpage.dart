import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hotelowner/api.dart';
import 'package:hotelowner/dashboard/bookingpage.dart';
import 'package:hotelowner/dashboard/pospage.dart';
import 'package:hotelowner/dashboard/roompage.dart';
import 'package:hotelowner/dashboard/transctionspage.dart';
import 'package:hotelowner/login/loginpage.dart';
import 'package:hotelowner/product/listpage.dart';
import 'package:hotelowner/product/productpage.dart';
import 'package:hotelowner/purchase/addpurchasereturn.dart';
import 'package:hotelowner/purchase/listpurchase.dart';
import 'package:hotelowner/sell/allsellpage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MainDashboardPage extends StatefulWidget {
  const MainDashboardPage({super.key});

  @override
  State<MainDashboardPage> createState() => _MainDashboardPageState();
}

class _MainDashboardPageState extends State<MainDashboardPage> {
  Widget _currentPage = const DashboardHome();

  void _onMenuItemSelected(Widget newPage) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => newPage),
    );
  }

  Future<void> _showLogoutConfirmation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Logout',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('OK',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    try {
      if (token != null) {
        final response = await http.post(
          Uri.parse(ApiConstants.logoutEndPoint),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
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
      await prefs.remove('auth_token');
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Loginpage()),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentPage.runtimeType == DashboardHome
          ? AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Beyond 360',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PosPage()));
                    },
                    child: const Icon(
                      Icons.point_of_sale_outlined,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              backgroundColor: const Color(0xFF312C51),
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
      backgroundColor: const Color(0xFF312C51),
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
                color: Color(0xFF312C51),
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(40)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child:
                        Icon(Icons.person, size: 50, color: Color(0xFF312C51)),
                  ),
                  SizedBox(height: 16),
                  Text('Hotel Owner',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Text('owner@gmail.com',
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            _buildDrawerItem(
                Icons.dashboard, 'Dashboard', const MainDashboardPage()),
            _buildDrawerItem(Icons.hotel, 'Rooms', const RoomsPage()),
            _buildDrawerItem(
                Icons.receipt_long, 'Transactions', const TransactionsPage()),
            _buildDrawerItem(Icons.download_for_offline_outlined, 'Add Prodcut',
                const AddProductPage()),
            _buildDrawerItem(Icons.list_alt_outlined, 'Products List',
                const ProductListPage()),
            _buildDrawerItem(
                Icons.list, 'List Purchase ', const PurchaseListPage()),
            _buildDrawerItem(Icons.add_card_outlined, 'Add Purchase',
                const AddPurchasePage()),
            _buildDrawerItem(
                Icons.point_of_sale_sharp, 'POS ', const PosPage()),
            _buildDrawerItem(Icons.production_quantity_limits_sharp,
                'All Sales ', const SellListPage()),
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
          color: isSelected ? const Color(0xFF312C51) : Colors.grey.shade700),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? const Color(0xFF312C51) : Colors.black87,
        ),
      ),
      selected: isSelected,
      selectedTileColor: const Color(0xFFFFF3E8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        if (isLogout) {
          _showLogoutConfirmation();
        } else if (page != null) {
          _onMenuItemSelected(page);
        }
      },
    );
  }
}

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  List<dynamic> recentTransactions = [];
  bool isLoadingTransactions = true;
  String transactionError = '';

  List<Map<String, dynamic>> revenueData = [];
  bool isLoadingRevenue = true;
  String selectedPeriod = 'Last 7 Days';

  int totalRooms = 0;
  int availableRooms = 0;
  int bookedRooms = 0;
  int maintenanceRooms = 0;
  bool isLoadingRooms = true;

  @override
  void initState() {
    super.initState();
    _fetchRecentTransactions();
    _fetchRevenueData();
    _fetchRoomAvailability();
  }

  Future<void> _fetchRoomAvailability() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      setState(() {
        isLoadingRooms = false;
      });
      return;
    }

    DateTime today = DateTime.now();
    String formattedDate =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    String url = ApiConstants.dailyroomDetailsEndPoint
        .replaceAll('{{value}}', formattedDate);

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
          final List<dynamic> dataList = jsonData['data'] ?? [];

          setState(() {
            if (dataList.isNotEmpty) {
              final firstDay = dataList[0];
              totalRooms = (firstDay['total_rooms'] as num?)?.toInt() ?? 0;
              availableRooms =
                  (firstDay['available_rooms'] as num?)?.toInt() ?? 0;
              bookedRooms = (firstDay['booked_rooms'] as num?)?.toInt() ?? 0;
              maintenanceRooms =
                  (firstDay['under_maintenance_rooms'] as num?)?.toInt() ?? 0;
            } else {
              // FIXED: No crash when data is empty
              totalRooms = 0;
              availableRooms = 0;
              bookedRooms = 0;
              maintenanceRooms = 0;
            }
            isLoadingRooms = false;
          });
        } else {
          setState(() {
            isLoadingRooms = false;
          });
        }
      } else {
        setState(() {
          isLoadingRooms = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingRooms = false;
      });
    }
  }

  Future<void> _fetchRecentTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      setState(() {
        isLoadingTransactions = false;
        transactionError = 'Not logged in';
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.latestPaymentEndPoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['success'] == true) {
          final List<dynamic> allTransactions =
              jsonData['data']['sell_transactions']['paid'] ?? [];
          setState(() {
            allTransactions.sort((a, b) => (b['transaction_date'] ?? '')
                .compareTo(a['transaction_date'] ?? ''));
            recentTransactions = allTransactions.take(5).toList();
            isLoadingTransactions = false;
          });
        } else {
          setState(() {
            transactionError = jsonData['message'] ?? 'No data';
            isLoadingTransactions = false;
          });
        }
      } else {
        setState(() {
          transactionError = 'Server error';
          isLoadingTransactions = false;
        });
      }
    } catch (e) {
      setState(() {
        transactionError = 'Network error';
        isLoadingTransactions = false;
      });
    }
  }

  Future<void> _fetchRevenueData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      setState(() {
        isLoadingRevenue = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.revenueDayEndPoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        if (jsonData['success'] == true) {
          final List<dynamic> rawData = jsonData['data'] ?? [];

          Map<String, double> revenueMap = {};
          for (var item in rawData) {
            String date = item['date'] ?? '';
            double revenue =
                double.tryParse(item['total_revenue']?.toString() ?? '0') ??
                    0.0;
            if (date.isNotEmpty) revenueMap[date] = revenue;
          }

          _updateRevenueGraph(revenueMap);
        } else {
          setState(() {
            isLoadingRevenue = false;
          });
        }
      } else {
        setState(() {
          isLoadingRevenue = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingRevenue = false;
      });
    }
  }

  void _updateRevenueGraph(Map<String, double> revenueMap) {
    int days = selectedPeriod == 'Last 7 Days' ? 7 : 15;

    List<Map<String, dynamic>> lastDays = [];
    DateTime today = DateTime.now();
    for (int i = days - 1; i >= 0; i--) {
      DateTime date = today.subtract(Duration(days: i));
      String formattedDate =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      String displayDate = '${date.day} ${[
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ][date.month]}';

      double revenue = revenueMap[formattedDate] ?? 0.0;

      lastDays.add({'date': displayDate, 'revenue': revenue});
    }

    setState(() {
      revenueData = lastDays;
      isLoadingRevenue = false;
    });
  }

  void _onPeriodChanged(String? newValue) {
    if (newValue != null && newValue != selectedPeriod) {
      setState(() {
        selectedPeriod = newValue;
        isLoadingRevenue = true;
      });
      _fetchRevenueData();
    }
  }

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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: const Color(0xFF48426D),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Reservation Details',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: const Color(0xFF48426D),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Available Rooms',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 20),
                  isLoadingRooms
                      ? const Center(child: CircularProgressIndicator())
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem(
                                Icons.hotel, totalRooms.toString(), 'Rooms'),
                            _buildStatItem(Icons.calendar_today,
                                availableRooms.toString(), 'Available'),
                            _buildStatItem(
                                Icons.bed, bookedRooms.toString(), 'Occupied'),
                            _buildStatItem(Icons.build,
                                maintenanceRooms.toString(), 'Maintenance'),
                          ],
                        ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Revenue Summary',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedPeriod,
                      icon: const Icon(Icons.arrow_drop_down, size: 10),
                      style: const TextStyle(fontSize: 11, color: Colors.black),
                      onChanged: _onPeriodChanged,
                      items: const [
                        DropdownMenuItem(
                            value: 'Last 7 Days', child: Text('Last 7 Days')),
                        DropdownMenuItem(
                            value: 'Last 15 Days', child: Text('Last 15 Days')),
                      ],
                    ),
                  ),
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
                      _buildLegendItem(const Color(0xFF48426D), 'Revenue'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  isLoadingRevenue
                      ? const SizedBox(
                          height: 150,
                          child: Center(child: CircularProgressIndicator()))
                      : SizedBox(
                          height: 150,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: revenueData.map((dayData) {
                                double revenue = dayData['revenue'] ?? 0.0;
                                double maxRevenue = revenueData.isEmpty
                                    ? 1
                                    : revenueData
                                        .map((e) => e['revenue'] as double)
                                        .reduce((a, b) => a > b ? a : b);
                                double height = maxRevenue > 0
                                    ? (revenue / maxRevenue) * 100
                                    : 0;
                                height = height.clamp(10.0, 100.0);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 36,
                                        height: height,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF48426D),
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(8)),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        dayData['date'],
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                  const SizedBox(height: 16),
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TransactionsPage()));
                    },
                    child: const Text('Show All',
                        style: TextStyle(color: Color(0xFF312C51)))),
              ],
            ),
            const SizedBox(height: 16),
            isLoadingTransactions
                ? const Center(child: CircularProgressIndicator())
                : transactionError.isNotEmpty
                    ? Center(
                        child: Text(transactionError,
                            style: const TextStyle(color: Colors.red)))
                    : recentTransactions.isEmpty
                        ? const Center(child: Text('No recent transactions'))
                        : Column(
                            children: recentTransactions.map((transaction) {
                              final String customerName =
                                  transaction['customer_name'] ??
                                      'Walk-In Customer';
                              final String invoiceNo =
                                  transaction['invoice_no'] ?? 'N/A';
                              final String amount =
                                  transaction['final_total']?.toString() ??
                                      '0.00';
                              final String status =
                                  (transaction['payment_status'] ?? 'unknown')
                                      .toString();

                              return _buildTransactionItem(
                                customerName,
                                'Inv: $invoiceNo • Rs. $amount • $status',
                              );
                            }).toList(),
                          ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String count, String label) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.white),
        const SizedBox(height: 8),
        Text(count,
            style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
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

  Widget _buildTransactionItem(String name, String details) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
              radius: 26,
              backgroundColor: Colors.grey.shade200,
              child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
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
