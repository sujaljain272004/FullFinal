 import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TrainSearchPage extends StatefulWidget {
  const TrainSearchPage({super.key});

  @override
  State<TrainSearchPage> createState() => _TrainSearchPageState();
}

class _TrainSearchPageState extends State<TrainSearchPage> {
  final _searchController = TextEditingController();
  bool _isLoading = false;
  List<Map<String, dynamic>> _trains = [];
  String? _error;

  Future<void> _searchTrains(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _trains = [];
    });

    try {
      // Using a different proxy service
      final response = await http.post(
        Uri.parse('https://api.allorigins.win/raw?url=${Uri.encodeComponent('https://trains.p.rapidapi.com/v1/railways/trains/india')}'),
        headers: {
          'Content-Type': 'application/json',
          'x-rapidapi-host': 'trains.p.rapidapi.com',
          'x-rapidapi-key': '0de887444cmsh78b43c52ff224a2p1d1864jsnfe12242de631',
        },
        body: json.encode({'search': query}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final trainsList = <Map<String, dynamic>>[];
        
        data.forEach((key, value) {
          if (key != 'data' && value is Map) {
            trainsList.add({
              'train_num': value['train_num'],
              'name': value['name'],
              'train_from': value['train_from'],
              'train_to': value['train_to'],
            });
          }
        });

        setState(() => _trains = trainsList);
      } else {
        setState(() => _error = 'Failed to fetch train details');
      }
    } catch (e) {
      setState(() => _error = 'Network error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Trains'),
        backgroundColor: const Color(0xFF4B5EFC),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter train name (e.g., Rajdhani)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchTrains(_searchController.text),
                ),
              ),
              onSubmitted: _searchTrains,
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _trains.length,
                itemBuilder: (context, index) {
                  final train = _trains[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(
                        train['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Train No: ${train['train_num']}\n'
                        'From: ${train['train_from']} To: ${train['train_to']}',
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}