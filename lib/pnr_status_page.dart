import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PNRStatusPage extends StatefulWidget {
  const PNRStatusPage({super.key});

  @override
  State<PNRStatusPage> createState() => _PNRStatusPageState();
}

class _PNRStatusPageState extends State<PNRStatusPage> {
  final _pnrController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _pnrData;
  String? _error;

  Future<void> _checkPNRStatus(String pnr) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _pnrData = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://irctc-indian-railway-pnr-status.p.rapidapi.com/getPNRStatus/$pnr'),
        headers: {
          'x-rapidapi-host': 'irctc-indian-railway-pnr-status.p.rapidapi.com',
          'x-rapidapi-key': '0de887444cmsh78b43c52ff224a2p1d1864jsnfe12242de631',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() => _pnrData = data['data']);
        } else {
          setState(() => _error = 'Invalid PNR number');
        }
      } else {
        setState(() => _error = 'Failed to fetch PNR status');
      }
    } catch (e) {
      setState(() => _error = 'Network error occurred');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildPNRDetails() {
    if (_pnrData == null) return const SizedBox.shrink();

    return Column(
      children: [
        // Header Card with PNR and Status
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF4B5EFC),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PNR Status',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'PNR: ${_pnrData!['pnrNumber']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _pnrData!['isWL'] == 'Y'
                            ? Colors.orange
                            : const Color(0xFF34C759),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _pnrData!['isWL'] == 'Y'
                                ? Icons.access_time
                                : Icons.check_circle,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _pnrData!['isWL'] == 'Y' ? 'Waitlisted' : 'Confirmed',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Train Details Card
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Train Number and Name
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4B5EFC).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.train,
                        color: Color(0xFF4B5EFC),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _pnrData!['trainNumber'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4B5EFC),
                            ),
                          ),
                          Text(
                            _pnrData!['trainName'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Journey Details
                _buildDetailTile(
                  icon: Icons.calendar_today,
                  title: 'Date of Journey',
                  value: _pnrData!['dateOfJourney'],
                ),
                _buildDetailTile(
                  icon: Icons.location_on,
                  title: 'From',
                  value: _pnrData!['sourceStation'],
                ),
                _buildDetailTile(
                  icon: Icons.location_on_outlined,
                  title: 'To',
                  value: _pnrData!['destinationStation'],
                ),
                _buildDetailTile(
                  icon: Icons.airline_seat_recline_normal,
                  title: 'Class',
                  value: _pnrData!['journeyClass'],
                ),
                _buildDetailTile(
                  icon: Icons.people,
                  title: 'Passengers',
                  value: _pnrData!['numberOfpassenger'].toString(),
                ),
                _buildDetailTile(
                  icon: Icons.article_outlined,
                  title: 'Chart Status',
                  value: _pnrData!['chartStatus'],
                  valueColor: _pnrData!['chartStatus'] == 'Chart Not Prepared'
                      ? Colors.orange
                      : const Color(0xFF34C759),
                ),
                _buildDetailTile(
                  icon: Icons.currency_rupee,
                  title: 'Booking Fare',
                  value: '₹${_pnrData!['bookingFare']}',
                  isLast: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4B5EFC).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF4B5EFC),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        color: valueColor ?? const Color(0xFF2C3E50),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              color: const Color(0xFF4B5EFC),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'PNR Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Search Section
            if (_pnrData == null)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
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
                          children: [
                            const Icon(
                              Icons.confirmation_number,
                              size: 48,
                              color: Color(0xFF4B5EFC),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[700]!),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                controller: _pnrController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Enter PNR Number',
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
                                  counterText: '${_pnrController.text.length}/10',
                                  counterStyle: TextStyle(color: Colors.grey[400]),
                                ),
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (_pnrController.text.length == 10) {
                                    _checkPNRStatus(_pnrController.text);
                                  }
                                },
                                icon: const Icon(Icons.search),
                                label: const Text('Get Status'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4B5EFC),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Results Section
            if (_pnrData != null)
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // PNR Status Header
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4B5EFC),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'PNR Number',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        _pnrData!['pnrNumber'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _pnrData!['isWL'] == 'Y'
                                          ? Colors.orange
                                          : const Color(0xFF34C759),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _pnrData!['isWL'] == 'Y'
                                              ? Icons.access_time
                                              : Icons.check_circle,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _pnrData!['isWL'] == 'Y'
                                              ? 'Waitlisted'
                                              : 'Confirmed',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Journey Details
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildJourneyDetailTile(
                                icon: Icons.train,
                                title: _pnrData!['trainNumber'],
                                subtitle: _pnrData!['trainName'],
                                showDivider: true,
                              ),
                              _buildJourneyDetailTile(
                                icon: Icons.calendar_today,
                                title: 'Journey Date',
                                subtitle: _pnrData!['dateOfJourney'],
                                showDivider: true,
                              ),
                              _buildJourneyDetailTile(
                                icon: Icons.location_on,
                                title: 'From - To',
                                subtitle: '${_pnrData!['sourceStation']} → ${_pnrData!['destinationStation']}',
                                showDivider: true,
                              ),
                              _buildJourneyDetailTile(
                                icon: Icons.airline_seat_recline_normal,
                                title: 'Class',
                                subtitle: _pnrData!['journeyClass'],
                                showDivider: true,
                              ),
                              _buildJourneyDetailTile(
                                icon: Icons.people,
                                title: 'Passengers',
                                subtitle: _pnrData!['numberOfpassenger'].toString(),
                                showDivider: true,
                              ),
                              _buildJourneyDetailTile(
                                icon: Icons.currency_rupee,
                                title: 'Fare',
                                subtitle: '₹${_pnrData!['bookingFare']}',
                                showDivider: false,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Loading Indicator
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4B5EFC)),
                ),
              ),

            // Error Message
            if (_error != null)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildJourneyDetailTile({
    required IconData icon,
    required String title,
    required String subtitle,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF4B5EFC).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF4B5EFC),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF2C3E50),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1),
      ],
    );
  }

  @override
  void dispose() {
    _pnrController.dispose();
    super.dispose();
  }
} 