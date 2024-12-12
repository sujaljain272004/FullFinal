import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TrainStatusPage extends StatefulWidget {
  const TrainStatusPage({super.key});

  @override
  State<TrainStatusPage> createState() => _TrainStatusPageState();
}

class _TrainStatusPageState extends State<TrainStatusPage> with SingleTickerProviderStateMixin {
  final _trainNumberController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  Map<String, dynamic>? _trainStatus;
  String? _error;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Section (only visible when no data)
            if (_trainStatus == null)
              SlideTransition(
                position: Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(0, -1),
                ).animate(_animationController),
                child: _buildSearchSection(),
              ),

            // Status Display Section
            Expanded(
              child: _trainStatus != null
                  ? FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildTrainStatusSection(),
                    )
                  : _buildLoadingOrError(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      color: Color(0xFF4B5EFC),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // App Bar
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                'Live Train Status',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Dark Search Card
          Card(
            elevation: 4,
            color: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Train Icon
                  const Center(
                    child: Icon(
                      Icons.train,
                      size: 48,
                      color: Color(0xFF4B5EFC),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Train Number Input
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[700]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _trainNumberController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Train Number',
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        prefixText: '# ',
                        prefixStyle: const TextStyle(
                          color: Color(0xFF4B5EFC),
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Date Selection
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[700]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Colors.grey[400],
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Date: ${DateFormat('dd MMM yyyy').format(_selectedDate)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Get Status Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _getTrainStatus,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B5EFC),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Get Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
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
        ],
      ),
    );
  }

  Widget _buildTrainStatusSection() {
    return CustomScrollView(
      slivers: [
        // Status Header
        SliverToBoxAdapter(
          child: Container(
            color: const Color(0xFF4B5EFC),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _trainStatus = null;
                          _animationController.reverse();
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        _trainStatus?['train_name'] ?? 'Train Status',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: () {
                        // Implement share functionality
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Last Updated: Just now',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Station Schedule Title
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Station Schedule',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B5EFC),
              ),
            ),
          ),
        ),

        // Update the StationStatusCard to use white background
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final station = _trainStatus!['stations'][index];
              return Container(
                color: Colors.white,
                child: StationStatusCard(
                  station: station,
                  isCurrentStation: station['stationCode'] == _trainStatus!['current_station_code'],
                ),
              );
            },
            childCount: _trainStatus!['stations']?.length ?? 0,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingOrError() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4B5EFC)),
        ),
      );
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: TextStyle(color: Colors.red[300]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  // Update your _getTrainStatus method
  Future<void> _getTrainStatus() async {
    if (_trainNumberController.text.isEmpty) {
      setState(() => _error = 'Please enter train number');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _trainStatus = null;
    });

    final dateStr = DateFormat('yyyyMMdd').format(_selectedDate);

    try {
      final response = await http.get(
        Uri.parse(
          'https://indian-railway-irctc.p.rapidapi.com/api/trains/v1/train/status'
          '?departure_date=$dateStr'
          '&isH5=true'
          '&client=web'
          '&train_number=${_trainNumberController.text}',
        ),
        headers: {
          'x-rapid-api': 'rapid-api-database',
          'x-rapidapi-host': 'indian-railway-irctc.p.rapidapi.com',
          'x-rapidapi-key': '0de887444cmsh78b43c52ff224a2p1d1864jsnfe12242de631',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == null && data['status']['result'] == 'success') {
          setState(() => _trainStatus = data['body']);
          _animationController.forward(); // Trigger the animation
        } else {
          setState(() => _error = 'Failed to fetch train status');
        }
      } else {
        setState(() => _error = 'Failed to fetch train status');
      }
    } catch (e) {
      setState(() => _error = 'Network error occurred');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 120)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _trainNumberController.dispose();
    super.dispose();
  }
}

// Add this custom widget for station status
class StationStatusCard extends StatelessWidget {
  final Map<String, dynamic> station;
  final bool isCurrentStation;

  const StationStatusCard({
    Key? key,
    required this.station,
    this.isCurrentStation = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side with station code and distance
          SizedBox(
            width: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  station['stationCode'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF2C3E50), // Darker color for station code
                  ),
                ),
                if (station['distance'] != null)
                  Text(
                    '${station['distance']} km',
                    style: const TextStyle(
                      color: Color(0xFF7F8C8D), // Slightly darker grey for distance
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          
          // Timeline dot and line
          Container(
            width: 16,
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isCurrentStation ? const Color(0xFF4B5EFC) : const Color(0xFFBDC3C7),
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFFBDC3C7),
                  ),
                ),
              ],
            ),
          ),
          
          // Station details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  station['stationName'] ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isCurrentStation ? FontWeight.w600 : FontWeight.w500,
                    color: isCurrentStation 
                        ? const Color(0xFF4B5EFC) 
                        : const Color(0xFF2C3E50), // Darker color for station name
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_downward, 
                      size: 14, 
                      color: Color(0xFF4B5EFC),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      station['arrivalTime'] ?? '-',
                      style: const TextStyle(
                        color: Color(0xFF2C3E50), // Darker color for time
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.arrow_upward, 
                      size: 14, 
                      color: Color(0xFF4B5EFC),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      station['departureTime'] ?? '-',
                      style: const TextStyle(
                        color: Color(0xFF2C3E50), // Darker color for time
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Platform
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F3F7), // Light background for platform
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'PF ${station['platform'] ?? '-'}',
              style: const TextStyle(
                color: Color(0xFF4B5EFC), // Theme color for platform number
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Add this class at the top of the file
class TrainStatusHeader extends StatelessWidget {
  final String trainNumber;
  final String trainName;
  final VoidCallback onShare;

  const TrainStatusHeader({
    Key? key,
    required this.trainNumber,
    required this.trainName,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF4B5EFC),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$trainNumber $trainName',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      trainName,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: onShare,
              ),
            ],
          ),
        ],
      ),
    );
  }
}