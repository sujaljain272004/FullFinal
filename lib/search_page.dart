import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'welcome_page.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:collection';

// Move translations map outside of any class to make it globally accessible
final Map<String, Map<String, String>> translations = {
  'English': {
    'search_city_hint': 'Search city...',
    'exploring': 'Exploring',
    'search_prompt': 'Search for a city to explore places',
    'market_places': 'Market Places',
    'restaurants': 'Restaurants',
    'tourist_places': 'Tourist Places',
    'hotels': 'Hotels',
    'open_in_maps': 'Open in Maps',
    'no_data_found': 'No data found for',
    'error_loading': 'Error loading data:',
    'select_language': 'Select Language',
  },
  'हिंदी (Hindi)': {
    'search_city_hint': 'शहर खोजें...',
    'exploring': 'खोज रहे हैं',
    'search_prompt': 'स्थानों की खोज के लिए एक शहर ��ोजें',
    'market_places': 'बाज़ार',
    'restaurants': 'रेस्तरां',
    'tourist_places': 'पर्यटन स्थल',
    'hotels': 'होटल',
    'open_in_maps': 'मैप में खोलें',
    'no_data_found': 'के लिए कोई डेटा नहीं मिला',
    'error_loading': 'डेटा लोड करने में त्रुटि:',
    'select_language': 'भाषा चुनें',
  },
  'मराठी (Marathi)': {
    'search_city_hint': 'शहर शोधा...',
    'exploring': 'एक्सप्लोर करत आहे',
    'search_prompt': 'ठिकाणे शोधण्यासाठी शहर शोधा',
    'market_places': 'बाजार',
    'restaurants': 'रेस्टॉरंट्स',
    'tourist_places': 'पर्यटन स्थळे',
    'hotels': 'हॉटेल्स',
    'open_in_maps': 'नकाशामध्ये उघडा',
    'no_data_found': 'साठी डेटा सापडला नाही',
    'error_loading': 'डेटा लोड करताना त्रुटी:',
    'select_language': 'भाषा निवडा',
  },
  'தமிழ் (Tamil)': {
    'search_city_hint': 'நகரத்தைத் தேடுங்கள்...',
    'exploring': 'ஆராய்கிறது',
    'search_prompt': 'இடங்களை ஆராய நகரத்தைத் தேடுங்கள்',
    'market_places': 'சந்தைகள்',
    'restaurants': 'உணவகங்கள்',
    'tourist_places': 'சுற்றுலா தலங்கள்',
    'hotels': 'ஹோட்டல்கள்',
    'open_in_maps': 'வரைபடங்களில் திற',
    'no_data_found': 'க்கான தரவு கிடைக்கவில்லை',
    'error_loading': 'தரவு ஏற்றுவதில் பிழை:',
    'select_language': 'மொழியைத் தேர்ந்தெடுக்கவும்',
  },
  'తెలుగు (Telugu)': {
    'search_city_hint': 'నగరాన్ని వెతకండి...',
    'exploring': 'అన్వేషిస్తోంది',
    'search_prompt': 'ప్రదేశాలను అన్వేషించడానికి నగరాన్ని వెతకండి',
    'market_places': 'మార్కెట్లు',
    'restaurants': 'రెస్టారెంట్లు',
    'tourist_places': 'పర్యాటక ప్రదేశాలు',
    'hotels': 'హోటళ్ళు',
    'open_in_maps': 'మ్యాప్‌లలో తెరవండి',
    'no_data_found': 'కోసం డేటా కనుగొనబడలేదు',
    'error_loading': 'డేటా లోడ్ చేయడంలో లోపం:',
    'select_language': 'భాషను ఎంచుకోండి',
  },
  'বাংলা (Bengali)': {
    'search_city_hint': 'শহর খুঁজুন...',
    'exploring': 'অন্বেষণ করছে',
    'search_prompt': 'স্থান অন্বেষণ করতে শহর খুঁজুন',
    'market_places': 'বাজার',
    'restaurants': 'রেস্তোরাঁ',
    'tourist_places': 'পর্যটন স্থান',
    'hotels': 'হোটেল',
    'open_in_maps': 'মানচিত্রে খুলুন',
    'no_data_found': 'এর জন্য কোন তথ্য পাওয়া যায়নি',
    'error_loading': 'তথ্য লোড করতে ত্রুটি:',
    'select_language': 'ভাষা নির্বাচন করুন',
  },
  'ગુજરાતી (Gujarati)': {
    'search_city_hint': 'શહેર શોધો...',
    'exploring': 'શોધી રહ્યા છીએ',
    'search_prompt': 'સ્થળો શોધવા માટે શહેર શોધો',
    'market_places': 'બજાર',
    'restaurants': 'રેસ્ટોર��્ટ',
    'tourist_places': 'પર્યટન સ્થળો',
    'hotels': 'હોટેલ',
    'open_in_maps': 'નકશામાં ખોલો',
    'no_data_found': 'માટે કોઈ માહિતી મળી નથી',
    'error_loading': 'માહિતી લોડ કરવામાં ભૂલ:',
    'select_language': 'ભાષા પસંદ કરો',
  },
  'ਪੰਜਾਬੀ (Punjabi)': {
    'search_city_hint': 'ਸ਼ਹਿਰ ਖੋਜੋ...',
    'exploring': 'ਖੋਜ ਕਰ ਰਿਹਾ ਹੈ',
    'search_prompt': 'ਥਾਵਾਂ ਦੀ ਖੋਜ ਲਈ ਸ਼ਹਿਰ ਖੋਜੋ',
    'market_places': 'ਬਾਜ਼ਾर',
    'restaurants': 'ਰੈਸਟੋਰੈਂਟ',
    'tourist_places': 'ਸੈਰ-ਸਪਾਟਾ ਥਾਵਾਂ',
    'hotels': 'ਹੋਟਲ',
    'open_in_maps': 'ਨਕਸ਼ੇ ਵਿੱਚ ਖੋਲ੍ਹੋ',
    'no_data_found': 'ਲਈ ਕੋਈ ਡੇਟਾ ਨਹੀਂ ਮਿਲਿਆ',
    'error_loading': 'ਡੇਟਾ ਲੋਡ ਕਰਨ ਵਿੱਚ ਤਰੁੱਟੀ:',
    'select_language': 'ਭਾਸ਼ਾ ਚੁਣੋ',
  },
  'ಕನ್ನಡ (Kannada)': {
    'search_city_hint': 'ನಗರ ಹುಡುಕಿ...',
    'exploring': 'ಅನ್ವೇಷಿಸಲಾಗುತ್ತಿದೆ',
    'search_prompt': 'ಸ್ಥಳಗಳನ್��ು ಅನ್ವೇಷಿಸಲು ನಗರವನ್ನು ಹುಡುಕಿ',
    'market_places': 'ಮಾರುಕಟ್ಟೆಗಳು',
    'restaurants': 'ರೆಸ್ಟೋರೆಂಟ್‌ಗಳು',
    'tourist_places': 'ಪ್ರವಾಸಿ ತಾಣಗಳು',
    'hotels': 'ಹೋಟೆಲ್‌ಗಳು',
    'open_in_maps': 'ನಕ್ಷೆಗಳಲ್ಲಿ ತೆರೆಯಿರಿ',
    'no_data_found': 'ಗಾಗಿ ಯಾವುದೇ ಡೇಟಾ ಕಂಡುಬಂದಿಲ್ಲ',
    'error_loading': 'ಡೇಟಾ ಲೋಡ್ ಮಾಡುವಲ್ಲಿ ದೋಷ:',
    'select_language': 'ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
  },
  'മലയാളം (Malayalam)': {
    'search_city_hint': 'നഗരം തിരയുക...',
    'exploring': 'പര്യവേക്ഷണം ചെയ്യുന്നു',
    'search_prompt': 'സ്ഥലങ്ങൾ കണ്ടെത്താൻ നഗരം തിരയുക',
    'market_places': 'മാർക്കറ്റുകൾ',
    'restaurants': 'റെസ്റ്റോറന്റുകൾ',
    'tourist_places': 'വിനോദസഞ്ചാര കേന്ദ്രങ്ങൾ',
    'hotels': 'ഹോട്ടലുകൾ',
    'open_in_maps': 'മാപ്പുകളിൽ തുറക്കുക',
    'no_data_found': 'ന് ���േണ്ടി ഡാറ്റ കണ്ടെത്തിയില്ല',
    'error_loading': 'ഡാറ്റ ലോഡ് ചെയ്യുന്നതിൽ പിശക്:',
    'select_language': 'ഭാഷ തിരഞ്ഞെടുക്കുക',
  },
  'ଓଡ଼ିଆ (Odia)': {
    'search_city_hint': 'ସହର ଖୋଜନ୍ତୁ...',
    'exploring': 'ନ୍ୱେଷଣ କରୁଛି',
    'search_prompt': 'ସ୍ଥାନ ଖୋଜିବାକୁ ସହର ଖୋଜନ୍ତୁ',
    'market_places': 'ବଜାର',
    'restaurants': 'ରେଷ୍ଟୁରାଣ୍ଟ',
    'tourist_places': 'ପର୍ଯ୍ୟଟନ ସ୍ଥଳୀ',
    'hotels': 'ହୋଟେଲ',
    'open_in_maps': 'ମାନଚିତ୍ରରେ ଖୋଲନ୍ତୁ',
    'no_data_found': 'ପାଇଁ କୌଣସି ତଥ୍ୟ ମିଳିଲା ନାହିଁ',
    'error_loading': 'ତଥ୍ୟ ଲୋଡ୍ କରିବାରେ ତ୍ରୁଟି:',
    'select_language': 'ଭାଷା ବାଛନ୍ତୁ',
  },
};

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  final FlutterTts _flutterTts = FlutterTts();
  String _selectedLanguage = 'English'; // Default language

  // Add animation controllers
  late AnimationController _controller;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _fadeAnimations;

  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _selectedCity = '';
  Map<String, dynamic>? _cityData;
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  // Add queue for TTS
  final Queue<String> _ttsQueue = Queue<String>();
  bool _isSpeaking = false;

  String _translate(String key) {
    return translations[_selectedLanguage]?[key] ?? translations['English']![key]!;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Create animations for each card
    _slideAnimations = List.generate(
      4,
      (index) => Tween<Offset>(
        begin: const Offset(0.35, 0.35),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.1,
            0.6 + (index * 0.1),
            curve: Curves.elasticOut,
          ),
        ),
      ),
    );

    // Add scale animations
    _scaleAnimations = List.generate(
      4,
      (index) => Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.1,
            0.6 + (index * 0.1),
            curve: Curves.easeOutBack,
          ),
        ),
      ),
    );

    // Add fade animations
    _fadeAnimations = List.generate(
      4,
      (index) => Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.1,
            0.6 + (index * 0.1),
            curve: Curves.easeIn,
          ),
        ),
      ),
    );

    _controller.forward();

    _initSpeech();

    // Initialize TTS completion handler
    _flutterTts.setCompletionHandler(() {
      if (_isSpeaking) {
        _speakNext();
      }
    });
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  Future<void> _startListening() async {
    await _speechToText.listen(
      onResult: (result) {
        setState(() {
          _searchController.text = result.recognizedWords;
          if (result.finalResult) {
            _searchCity(result.recognizedWords);
          }
        });
      },
    );
  }

  Future<void> _searchCity(String city) async {
    if (city.isEmpty) return;

    setState(() {
      _isSearching = true;
      _cityData = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://sih-pravaah.onrender.com/api/itineraries/search/$city'),
        headers: {'accept': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Connection timed out. Please try again.');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _cityData = data['data'];
          _selectedCity = city;
        });
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_translate('no_data_found')} $city')),
        );
      } else {
        throw Exception('Failed to load city data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_translate('error_loading')} ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    _speechToText.stop();
    _flutterTts.stop();
    _ttsQueue.clear();
    super.dispose();
  }

  Future<void> _readAloud(List<String> texts) async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      _ttsQueue.clear();
      _isSpeaking = false;
      return;
    }

    _ttsQueue.addAll(texts);
    _isSpeaking = true;
    await _speakNext();
  }

  Future<void> _speakNext() async {
    if (_ttsQueue.isEmpty) {
      _isSpeaking = false;
      return;
    }

    await _flutterTts.setLanguage(_getTtsLanguage());
    await _flutterTts.speak(_ttsQueue.removeFirst());

    _flutterTts.setCompletionHandler(() {
      if (_isSpeaking) {
        _speakNext();
      }
    });
  }

  // Add method to get all texts to read
  List<String> _getTextsToRead() {
    List<String> texts = [
      _translate('search_prompt'),
      _translate('market_places'),
      _translate('restaurants'),
      _translate('tourist_places'),
      _translate('hotels'),
    ];
    return texts;
  }

  String _getTtsLanguage() {
    switch (_selectedLanguage) {
      case 'हिंदी (Hindi)':
        return 'hi-IN';
      case 'मराठी (Marathi)':
        return 'mr-IN';
      case 'தமிழ் (Tamil)':
        return 'ta-IN';
      case 'తెలుగు (Telugu)':
        return 'te-IN';
      case 'বাংলা (Bengali)':
        return 'bn-IN';
      case 'ગુજરાતી (Gujarati)':
        return 'gu-IN';
      case 'ਪੰਜਾਬੀ (Punjabi)':
        return 'pa-IN';
      case 'ಕನ್ನಡ (Kannada)':
        return 'kn-IN';
      case 'മലയാളം (Malayalam)':
        return 'ml-IN';
      case 'ଓଡ଼ିଆ (Odia)':
        return 'or-IN';
      default:
        return 'en-US';
    }
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocalizationService.translate('select_language')),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                _buildLanguageOption('English'),
                _buildLanguageOption('हिंदी (Hindi)'),
                _buildLanguageOption('मराठी (Marathi)'),
                _buildLanguageOption('தமிழ் (Tamil)'),
                _buildLanguageOption('తెలుగు (Telugu)'),
                _buildLanguageOption('বাংলা (Bengali)'),
                _buildLanguageOption('ગુજરાતી (Gujarati)'),
                _buildLanguageOption('ਪੰਜਾਬੀ (Punjabi)'),
                _buildLanguageOption('ಕನ್ನಡ (Kannada)'),
                _buildLanguageOption('മലയാളം (Malayalam)'),
                _buildLanguageOption('ଓଡ଼ିଆ (Odia)'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String language) {
    return ListTile(
      title: Text(language),
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
        Navigator.pop(context);
      },
      trailing: _selectedLanguage == language
          ? const Icon(Icons.check, color: Color(0xFF4A5CFF))
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background color
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                _isSpeaking ? Icons.stop : Icons.volume_up,
                color: const Color(0xFF4B5EFC),
              ),
              onPressed: () {
                if (_isSpeaking) {
                  _flutterTts.stop();
                  setState(() {
                    _isSpeaking = false;
                    _ttsQueue.clear();
                  });
                } else {
                  _readAloud(_getTextsToRead());
                }
              },
              tooltip: _isSpeaking ? 'Stop Speaking' : 'Read Aloud',
            ),
            IconButton(
              icon: const Icon(Icons.language, color: Color(0xFF4B5EFC)),
              onPressed: _showLanguageDialog,
              tooltip: 'Change Language',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar with enhanced styling
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(
                color: Color(0xFF4B5EFC),
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: _translate('search_city_hint'),
                hintStyle: TextStyle(color: const Color(0xFF4B5EFC).withOpacity(0.5)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF4B5EFC)),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xFF4B5EFC)),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _selectedCity = '';
                            _cityData = null;
                          });
                        },
                      ),
                    IconButton(
                      icon: Icon(
                        _speechToText.isListening ? Icons.mic : Icons.mic_none,
                        color: const Color(0xFF4B5EFC),
                      ),
                      onPressed: _speechEnabled ? _startListening : null,
                    ),
                  ],
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onSubmitted: _searchCity,
            ),
          ),

          // Loading indicator or Grid
          if (_isSearching)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFF4B5EFC)),
              ),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_selectedCity.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 16),
                          child: Text(
                            '${_translate('exploring')} $_selectedCity',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4B5EFC),
                            ),
                          ),
                        ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          bool isEnabled = _selectedCity.isNotEmpty && _cityData != null;
                          return _buildModernCard(
                            index: index,
                            title: _getCategoryTitle(index),
                            icon: _getCategoryIcon(index),
                            color: _getCategoryColor(index),
                            isEnabled: isEnabled,
                            data: _cityData,
                          );
                        },
                      ),
                      if (_selectedCity.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_rounded,
                                  size: 80,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _translate('search_prompt'),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
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
        ],
      ),
    );
  }

  String _getCategoryTitle(int index) {
    switch (index) {
      case 0:
        return _translate('market_places');
      case 1:
        return _translate('restaurants');
      case 2:
        return _translate('tourist_places');
      case 3:
        return _translate('hotels');
      default:
        return '';
    }
  }

  IconData _getCategoryIcon(int index) {
    switch (index) {
      case 0:
        return Icons.store;
      case 1:
        return Icons.restaurant;
      case 2:
        return Icons.tour;
      case 3:
        return Icons.hotel;
      default:
        return Icons.error;
    }
  }

  Color _getCategoryColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF4B5EFC);
      case 1:
        return const Color(0xFF4CAF50);
      case 2:
        return const Color(0xFFFF9800);
      case 3:
        return const Color(0xFF9C27B0);
      default:
        return Colors.grey;
    }
  }

  Widget _buildModernCard({
    required int index,
    required String title,
    required IconData icon,
    required Color color,
    required bool isEnabled,
    Map<String, dynamic>? data,
  }) {
    return GestureDetector(
      onTap: () {
        if (isEnabled) {
          // Existing navigation logic
          List<dynamic>? categoryData;
          switch (index) {
            case 0:
              categoryData = data?['market_places'];
              break;
            case 1:
              categoryData = data?['restaurants'];
              break;
            case 2:
              categoryData = data?['tourist_spots'];
              break;
            case 3:
              categoryData = data?['hotels'];
              break;
          }
          if (categoryData != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryDetailPage(
                  title: title,
                  data: categoryData!,
                  color: color,
                  selectedLanguage: _selectedLanguage,
                ),
              ),
            );
          }
        } else {
          // Show snackbar when disabled options are clicked
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.location_city,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Please Enter the City',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: const Color(0xFF4B5EFC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color,
                    color.withOpacity(0.8),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    bottom: -20,
                    child: Icon(
                      icon,
                      size: 100,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          size: 32,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Add a new CategoryDetailPage to display the items
class CategoryDetailPage extends StatelessWidget {
  final String title;
  final List<dynamic> data;
  final Color color;
  final String selectedLanguage;

  const CategoryDetailPage({
    super.key,
    required this.title,
    required this.data,
    required this.color,
    required this.selectedLanguage,
  });

  String _translate(String key) {
    return translations[selectedLanguage]?[key] ?? translations['English']![key]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color,
      ),
      body: ListView.builder(
        itemCount: data.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final item = data[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item['image_url'] != null)
                  Image.network(
                    item['image_url'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.error, size: 100, color: Colors.red[300]),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'] ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(item['address'] ?? 'N/A'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          Text(' ${item['ratings']?.toString() ?? 'N/A'}'),
                        ],
                      ),
                      if (item['map_url'] != null)
                        TextButton.icon(
                          icon: const Icon(Icons.map),
                          label: Text(_translate('open_in_maps')),
                          onPressed: () => launch(item['map_url']),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
