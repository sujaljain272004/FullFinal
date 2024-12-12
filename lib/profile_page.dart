import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

const translations = {
  'en-US': {
    'profileTitle': 'Profile',
    'signIn': 'Sign In',
    'signUp': 'Sign Up',
    'loginTitle': 'Login',
    'signInToYourAccount': 'Sign in to your account',
    'emailAddress': 'Email Address',
    'password': 'Password',
    'forgotPassword': 'Forgot Password?',
    'confirm': 'Confirm',
    'signUpTitle': 'Sign Up',
    'name': 'Name',
    'mobileNumber': 'Mobile Number',
    'confirmPassword': 'Confirm Password',
    'logout': 'Logout',
    'newUserSignUp': 'New User? Sign Up to continue',
  },
  'hi-IN': {
    'profileTitle': 'प्रोफ़ाइल',
    'signIn': 'साइन इन करें',
    'signUp': 'साइन अप करें',
    'loginTitle': 'लॉगिन',
    'signInToYourAccount': 'अपने खाते में सइन इन करें',
    'emailAddress': 'ेल पता',
    'password': 'पासवर्ड',
    'forgotPassword': 'पासवर्ड भूल गए?',
    'confirm': 'पुष्टि करें',
    'signUpTitle': 'साइन अप',
    'name': 'नाम',
    'mobileNumber': 'मोबाइल नंबर',
    'confirmPassword': 'पासवर्ड की पुष्टि करें',
    'logout': 'लॉग आउट',
    'newUserSignUp': 'नए उपयोगकर्ता? जारी रखने के लिए साइन अप करें',
  },
  'mr-IN': {
    'profileTitle': 'प्रोफाइल',
    'signIn': 'साइन इन',
    'signUp': 'साइन अप',
    'loginTitle': 'लॉगिन',
    'signInToYourAccount': 'तुमच्या खात्यात साइन इन करा',
    'emailAddress': 'ईमेल पत्ता',
    'password': 'पासवर्ड',
    'forgotPassword': 'पासवर्ड विसरलात?',
    'confirm': 'पुष्टी करा',
    'signUpTitle': 'साइन अप',
    'name': 'नाव',
    'mobileNumber': 'मोबाइल नंबर',
    'confirmPassword': 'पासवर्डची पुष्टी करा',
    'logout': 'लॉगआउट',
    'newUserSignUp': 'नवीन वापरकर्ता? सुरू ठेवण्यासाठी साइन अप करा',
  },
  'ta-IN': {
    'profileTitle': 'சுயவிவரம்',
    'signIn': 'உள்நுழைவு',
    'signUp': 'பதிவு செய்யவும்',
    'loginTitle': 'உள்நுழையவும்',
    'signInToYourAccount': 'உங்கள் கணக்கில் உள்நுழைக',
    'emailAddress': 'மின்னஞ்சல் முகவரி',
    'password': 'கடவுச்சொல்',
    'forgotPassword': 'கடவுச்சொல் மறந்துவிட்டதா?',
    'confirm': 'உறுதிப்படுத்தவும்',
    'signUpTitle': 'பதிவு செய்யவும்',
    'name': 'பெயர்',
    'mobileNumber': 'மொபைல் எண்',
    'confirmPassword': 'கடவுச்சொல்லை உறுதிப்படுத்தவும்',
    'logout': 'லோகெட்',
    'newUserSignUp': 'புதிய பயனரா? தொடர பதிவு செய்யவும்',
  },
  'te-IN': {
    'profileTitle': 'ప్రొఫైల్',
    'signIn': 'సైన్ ఇన్ చేయండి',
    'signUp': 'చేరండి',
    'loginTitle': 'లాగిన్',
    'signInToYourAccount': 'మీ ఖాతాలో సైన్ ఇన్ చేయండి',
    'emailAddress': 'ఇమెయిల్ చిరునామా',
    'password': 'పాస్వర్డ్',
    'forgotPassword': 'పాస్వర్డ్ మర్చిపోయారా?',
    'confirm': 'నిర్ధారించండి',
    'signUpTitle': 'చేరండి',
    'name': 'పేరు',
    'mobileNumber': 'మొబైల్ నంబర్',
    'confirmPassword': 'పాస్వర్డ్ నిర్ధారించండి',
    'logout': 'లోగెట్',
    'newUserSignUp': 'కొత్త వినియోగదారుడా? కొనసాగించడానికి సైన్ అప్ చేయండి',
  },
  'bn-IN': {
    'profileTitle': 'প্রোফাইল',
    'signIn': 'সাইন ইন করুন',
    'signUp': 'সাইন আপ করুন',
    'loginTitle': 'লগইন',
    'signInToYourAccount': 'আপনার অ্যাকাউন্টে সাইন ইন করুন',
    'emailAddress': 'ইমেল ঠিকানা',
    'password': 'পাসওয়ার্ড',
    'forgotPassword': 'পাসওয়ার্ড ভুলে গেছেন?',
    'confirm': 'নশ্চিত করুন',
    'signUpTitle': 'সাইন আপ করুন',
    'name': 'নাম',
    'mobileNumber': 'মোবাইল নম্বর',
    'confirmPassword': 'পাসওয়ার্ড নিশ্চিত করুন',
    'logout': 'লগ আউট',
    'newUserSignUp': 'নতুন ব্যবহারকারী? চালিয়ে যেতে সাইন আপ করুন',
  },
  'gu-IN': {
    'profileTitle': 'પ્રોફાઇલ',
    'signIn': 'સાઇન ઇન કરો',
    'signUp': 'સાઇન અપ કરો',
    'loginTitle': 'લૉગિન',
    'signInToYourAccount': 'તમારા ખાતામાં સાઇન ઇન કરો',
    'emailAddress': 'ઇમેઇલ સરનામું',
    'password': 'પાસવર્ડ',
    'forgotPassword': 'પાસર્ડ ભૂલી ગયા છો?',
    'confirm': 'પુષ્ટિ કરો',
    'signUpTitle': 'સાઇન અપ',
    'name': 'નામ',
    'mobileNumber': 'મોબાઇલ નંબર',
    'confirmPassword': 'પાસવર્ડની પુષ્ટિ કરો',
    'logout': 'લોગ આઉટ',
    'newUserSignUp': 'નવા વપરાશકર્તા? ચાલુ રાખવા માટે સાઇન અપ કરો',
  },
  'pa-IN': {
    'profileTitle': 'ਪ੍ਰੋਫਾਈਲ',
    'signIn': 'ਸਾਈਨ ਇਨ ਕਰੋ',
    'signUp': 'ਸਾਈਨ ਅਪ ਕਰੋ',
    'loginTitle': 'ਲਾਗਿਨ',
    'signInToYourAccount': 'ਆਪਣੇ ਖਾਤੇੇ ਵਿੱਚ ਸਾਈਨ ਇਨ ਕਰੋ',
    'emailAddress': 'ਈਮੇਲ ਪਤਾ',
    'password': 'ਪਾਸਵਰਡ',
    'forgotPassword': 'ਪਾਸਵਰਡ ਭੁੱਲ ਗਏ?',
    'confirm': 'ਪੁਸ਼ਟੀ ਕਰੋ',
    'signUpTitle': 'ਸਾਈਨ ਅਪ ਕਰੋ',
    'name': 'ਨਾਮ',
    'mobileNumber': 'ਮੋਬਾਈਈਈਲ ਨੰਬਰ',
    'confirmPassword': 'ਪਾਸਵਰਡ ਦੀ ਪੁਸ਼ਟੀ ਕਰੋ',
    'logout': 'ਲੋਗ ਆਉਟ',
    'newUserSignUp': 'ਨਵਾਂ ਯੂਜ਼ਰ? ਜਾਰੀ ਰੱਖਣ ਲਈ ਸਾਈਨ ਅੱਪ ਕਰੋ',
  },
  'kn-IN': {
    'profileTitle': 'ಪ್ರೊಫೈಲ್',
    'signIn': 'ಸೈನ್ ಇನ್ ಮಾಡಿ',
    'signUp': 'ಸೈನ್ ಅಪ್ ಮಾಡಿ',
    'loginTitle': 'ಲಾಗಿನ್',
    'signInToYourAccount': 'ನಿಮ್ಮ ಖಾತೆಗೆ ಸೈನ್ ಇನ್ ಮಾಡಿ',
    'emailAddress': 'ಇಮೇಲ್ ವಿಳಾಸ',
    'password': 'ಪಾಸ್‌ವರ್ಡ್',
    'forgotPassword': 'ಪಾಸ್‌ವರ್ಡ್ ಮರೆತಿದ್ದೀರಾ?',
    'confirm': 'ದೃಢೀಕರಿಸಿ',
    'signUpTitle': 'ಸೈನ್ ಅಪ್',
    'name': 'ಹೆಸರು',
    'mobileNumber': 'ಮೊಬೈಲ್ ನಂಬರ್',
    'confirmPassword': 'ಪಾಸ್‌ವರ್ಡ್ ದೃಢೀಕರಿಸಿ',
    'logout': 'ಲೋಗೆಟ್',
    'newUserSignUp': 'ಹೊಸ ಬಳಕೆದಾರ? ಮುಂದುವರಿಯಲು ಸೈನ್ ಅಪ್ ಮಾಡಿ',
  },
  'ml-IN': {
    'profileTitle': 'പ്രൊഫൈൽ',
    'signIn': 'സൈൻ ഇൻ ചെയ്യുക',
    'signUp': 'സൈൻ അപ്പ് ചെയ്യുക',
    'loginTitle': 'ലോഗിൻ',
    'signInToYourAccount': 'നിങ്ങളുടെ അക്കൗണ്ടിൽ സൈൻ ഇൻ ചെയ്യുക',
    'emailAddress': 'ഇമെയിൽ വിലാസം',
    'password': 'പാസ്വേഡ്',
    'forgotPassword': 'പാസ്വേഡ് മറന്നോ?',
    'confirm': 'സ്ഥിരീകരിക്കുക',
    'signUpTitle': 'സൈൻ അപ്പ് ചെയ്യുക',
    'name': 'പേര്',
    'mobileNumber': 'മൊബൈൽ നമ്പർ',
    'confirmPassword': 'പാസ്വേഡ് സ്ഥിരീകരിക്കുക',
    'logout': 'ലോഗെട്',
    'newUserSignUp': 'പുതിയ ഉപയോക്താവ്? തുടരാൻ സൈൻ അപ്പ് ചെയ്യുക',
  },
  'or-IN': {
    'profileTitle': 'ପ୍ରୋଫାଇଲ୍',
    'signIn': 'ସାଇନ୍ ଇନ୍ କରନ୍ତୁ',
    'signUp': 'ସାଇନ୍ ଅପ୍ କରନ୍ତୁ',
    'loginTitle': 'ଲଗଇନ୍',
    'signInToYourAccount': 'ଆପଣଙ୍କର ଖାତାରେ ସାଇନ୍ ଇନ୍ କରନ୍ତୁ',
    'emailAddress': 'ଇମେଲ୍ ଠିକଣା',
    'password': 'ପାସୱାର୍ଡ',
    'forgotPassword': 'ପାସୱାର୍ଡ ଭୁଲିଗଲାନି?',
    'confirm': 'ନିଶ୍ଚିତ କରନ୍ତୁ',
    'signUpTitle': 'ସାଇନ୍ ଅପ୍ କରନ୍ତୁ',
    'name': 'ନାମ',
    'mobileNumber': 'ମୋବାଇଲ୍ ନମ୍ବର',
    'confirmPassword': 'ପାସୱାର୍ଡ ନିଶ୍ଚିତ କରନ୍ତୁ',
    'logout': 'ଲୋଗ୆ଟ୍',
    'newUserSignUp': 'ନୂଆ ୟୁଜର୍? ଜାରି ରଖିବାକୁ ସାଇନ୍ ଅପ୍ କରନ୍ତୁ',
  },
};

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  String _selectedLanguage = 'en-US';
  final FlutterTts _flutterTts = FlutterTts();
  String? _userEmail;
  String? _userName;
  String? _userToken;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Add languages list
  final List<String> languages = [
    'English',
    'हिंदी (Hindi)',
    'मराठी (Marathi)',
    'தமிழ் (Tamil)',
    'తెలుగు (Telugu)',
    'বাংলা (Bengali)',
    'ગુજરાતી (Gujarati)',
    'ਪੰਜਾਬੀ (Punjabi)',
    'ಕನ್ನಡ (Kannada)',
    'മലയാളം (Malayalam)', 
    'ଓଡ଼ିଆ (Odia)',
  ];

  get translation => null;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _loadUserData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  // Add speak method
  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage(_selectedLanguage);
    await _flutterTts.speak(text);
  }

  // Add language update method
  Future<void> _updateLanguage(String language) async {
    final String langCode = _getLanguageCode(language);
    setState(() {
      _selectedLanguage = langCode;
    });
    // Optionally save selected language to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', langCode);
  }

  // Add language code helper method
  String _getLanguageCode(String language) {
    switch (language) {
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

  // Add language dialog method
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: languages.map((String language) {
                return ListTile(
                  title: Text(language),
                  onTap: () {
                    _updateLanguage(language);
                    Navigator.pop(context);
                  },
                  trailing: _getLanguageCode(language) == _selectedLanguage
                      ? const Icon(Icons.check, color: Color(0xFF4B5EFC))
                      : null,
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  // Load saved user data
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString('userEmail');
      _userName = prefs.getString('userName');
      _userToken = prefs.getString('userToken');
      if (_userEmail != null && _userName != null) {
        _animationController.forward();
      }
    });
  }

  // Add logout function
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
    await prefs.remove('userName');
    await prefs.remove('userToken');
    setState(() {
      _userEmail = null;
      _userName = null;
      _userToken = null;
    });
  }

  // Add refresh method
  void _refreshProfile() {
    setState(() {
      _loadUserData();
    });
  }

  // Update your build method to use these methods
  @override
  Widget build(BuildContext context) {
    final translation = translations[_selectedLanguage]!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        title: const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(''),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.volume_up,
                    color: Color(0xFF4B5EFC),
                    size: 24,
                  ),
                  onPressed: () => _speak(translation['profileTitle']!),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.language,
                    color: Color(0xFF4B5EFC),
                    size: 24,
                  ),
                  onPressed: () => _showLanguageDialog(context),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_userEmail != null && _userName != null)
              _buildUserInfo()
            else
              // Show login/signup buttons when not logged in
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LoginPage(selectedLanguage: _selectedLanguage),
                        ),
                      );
                      if (result == true) {
                        _refreshProfile(); // Refresh the profile when login is successful
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4B5EFC),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      minimumSize: const Size(250, 50),
                      elevation: 5,
                      shadowColor: const Color(0xFF4B5EFC).withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(
                          color: Color(0xFF4B5EFC),
                          width: 2,
                        ),
                      ),
                      animationDuration: const Duration(milliseconds: 200),
                    ),
                    child: Text(
                      translation['signIn']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(
                      height: 20), // Space between sign in and divider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Divider(color: Colors.grey),
                        ),
                      ),
                      Text(
                        translation['newUserSignUp']!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Divider(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: 20), // Space between divider and sign up
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(
                                selectedLanguage: _selectedLanguage,
                              ),
                            ),
                          );
                          if (result == true) {
                            _refreshProfile();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4B5EFC),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          minimumSize: const Size(250, 50),
                          elevation: 5,
                          shadowColor: const Color(0xFF4B5EFC).withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          animationDuration: const Duration(milliseconds: 200),
                        ),
                        child: Text(
                          translation['signUp']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Add spacing after sign up button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Divider(color: Colors.grey),
                        ),
                      ),
                      Text(
                        'OR',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Divider(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: SizedBox(
                      width: 250, // Match the width of other buttons
                      height: 50,
                      child: OutlinedButton.icon(
                        icon: Image.asset(
                          'assets/google-logo.png',
                          height: 24,
                        ),
                        label: const Text(
                          'Continue with Google',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onPressed: () async {
                          try {
                            final user = await GoogleSignInApi.login();
                            if (user != null) {
                              // Send user details to backend
                              final response = await http.post(
                                Uri.parse('https://sih-pravaah.onrender.com/api/auth/google-signin'),
                                headers: {
                                  'Content-Type': 'application/json',
                                },
                                body: json.encode({
                                  'email': user.email,
                                  'name': user.displayName,
                                  'googleId': user.id,
                                }),
                              );

                              if (response.statusCode == 200) {
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setString('userName', user.displayName ?? '');
                                await prefs.setString('userEmail', user.email);
                                await prefs.setBool('isLoggedIn', true);

                                if (mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WelcomePage(username: user.displayName ?? ''),
                                    ),
                                  );
                                }
                              }
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Sign in failed: ${e.toString()}')),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    final translation = translations[_selectedLanguage]!;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: Stack(
            children: [
              // Center the user info
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFF4B5EFC),
                      child: Text(
                        _userName![0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _userName!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4B5EFC), // App theme color
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _userEmail!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4B5EFC), // App theme color
                      ),
                    ),
                  ],
                ),
              ),
              // Logout button at extreme bottom right
              Positioned(
                bottom: 0, // Extreme bottom
                right: 0, // Extreme right
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 16),
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _showLogoutConfirmation(context, translation),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    label: Text(
                      translation['logout']!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showLogoutConfirmation(
      BuildContext context, Map<String, String> translation) async {
    await showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );

        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Color(0xFF4B5EFC),
                    size: 28,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Confirm Logout',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B5EFC),
                    ),
                  ),
                ],
              ),
              content: const Text(
                'Are you sure you want to log out?',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4B5EFC),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF4B5EFC),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _logout();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    elevation: 2,
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
    );
  }
}

class LoginPage extends StatefulWidget {
  final String selectedLanguage;

  const LoginPage({super.key, required this.selectedLanguage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FlutterTts _flutterTts = FlutterTts();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  // Add new state variable for password visibility
  bool _passwordVisible = false;

  Future<void> _speak(String text, String signInText, String signUpText) async {
    final String speechText =
        '$text. $signInText or $signUpText? Please choose.';
    await _flutterTts.setLanguage(widget.selectedLanguage);
    await _flutterTts.speak(speechText);
  }

  void _showLanguageDialog(BuildContext context) {
    final List<String> languages = [
      'English',
      'हंदी (Hindi)',
      'मराठी (Marathi)',
      'தமிழ் (Tamil)',
      'తెలుగు (Telugu)',
      'বাংলা (Bengali)',
      'ગુજરાતી (Gujarati)',
      'ਪੰਜਾਬੀ (Punjabi)',
      'ಕನ್ನಡ (Kannada)',
      'മലയാളം (Malayalam)',
      'ଓଡ଼ିଆ (Odia)',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: languages.map((String language) {
                return ListTile(
                  title: Text(language),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(
                          selectedLanguage: _getLanguageCode(language),
                        ),
                      ),
                    );
                  },
                  trailing:
                      _getLanguageCode(language) == widget.selectedLanguage
                          ? const Icon(Icons.check, color: Color(0xFF4B5EFC))
                          : null,
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  String _getLanguageCode(String language) {
    switch (language) {
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

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http
          .post(
        Uri.parse('https://sih-pravaah.onrender.com/api/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Connection timed out. Please try again.');
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (mounted) {
          final prefs = await SharedPreferences.getInstance();
          // Save user data
          await prefs.setString('userEmail', responseData['user']['email']);
          await prefs.setString('userName', responseData['user']['username']);
          await prefs.setString('userToken', responseData['token']);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );
          Navigator.pop(context, true); // Pass true to indicate success
        }
      } else {
        setState(() {
          _errorMessage =
              responseData['message'] ?? 'Login failed: ${response.statusCode}';
        });
      }
    } on TimeoutException catch (_) {
      setState(() {
        _errorMessage =
            'Connection timed out. Please check your internet connection.';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final translation = translations[widget.selectedLanguage]!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF4B5EFC),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.volume_up,
              color: Color(0xFF4B5EFC),
            ),
            onPressed: () => _speak(
              translation['signInToYourAccount']!,
              translation['emailAddress']!,
              translation['password']!,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.language,
              color: Color(0xFF4B5EFC),
            ),
            onPressed: () => _showLanguageDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 80,
                    color: Color(0xFF4B5EFC),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    translation['signInToYourAccount']!,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B5EFC),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(
                      color: Color(0xFF4B5EFC),
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      labelText: translation['emailAddress']!,
                      labelStyle: const TextStyle(color: Color(0xFF4B5EFC)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: const Color(0xFF4B5EFC).withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                            color: Color(0xFF4B5EFC), width: 2),
                      ),
                      prefixIcon:
                          const Icon(Icons.email, color: Color(0xFF4B5EFC)),
                      filled: true,
                      fillColor: const Color(0xFF4B5EFC).withOpacity(0.05),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    style: const TextStyle(
                      color: Color(0xFF4B5EFC),
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      labelText: translation['password']!,
                      labelStyle: const TextStyle(color: Color(0xFF4B5EFC)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: const Color(0xFF4B5EFC).withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                            color: Color(0xFF4B5EFC), width: 2),
                      ),
                      prefixIcon:
                          const Icon(Icons.lock, color: Color(0xFF4B5EFC)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xFF4B5EFC),
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: const Color(0xFF4B5EFC).withOpacity(0.05),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Forgot Password Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(
                              selectedLanguage: widget.selectedLanguage,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        translation['forgotPassword']!,
                        style: const TextStyle(
                          color: Color(0xFF4B5EFC),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Error Message
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B5EFC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              translation['confirm']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class SignUpPage extends StatefulWidget {
  String selectedLanguage; // Make it mutable like in the sign-in page

  SignUpPage({
    super.key,
    required this.selectedLanguage,
  });

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isLoading = false;
  String _errorMessage = '';
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage(widget.selectedLanguage);
    await _flutterTts.speak(text);
  }

  // Language dialog method
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () {
                  setState(() {
                    widget.selectedLanguage = 'en-US';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('हिंदी (Hindi)'),
                onTap: () {
                  setState(() {
                    widget.selectedLanguage = 'hi-IN';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('मराठी (Marathi)'),
                onTap: () {
                  setState(() {
                    widget.selectedLanguage = 'mr-IN';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('தமிழ் (Tamil)'),
                onTap: () {
                  setState(() {
                    widget.selectedLanguage = 'ta-IN';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('తెలుగు (Telugu)'),
                onTap: () {
                  setState(() {
                    widget.selectedLanguage = 'te-IN';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('বাংলা (Bengali)'),
                onTap: () {
                  setState(() {
                    widget.selectedLanguage = 'bn-IN';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('ગુજરાતી (Gujarati)'),
                onTap: () {
                  setState(() {
                    widget.selectedLanguage = 'gu-IN';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('ਪੰਜਾਬੀ (Punjabi)'),
                onTap: () {
                  setState(() {
                    widget.selectedLanguage = 'pa-IN';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('ಕನ್ನಡ (Kannada)'),
                onTap: () {
                  setState(() {
                    widget.selectedLanguage = 'kn-IN';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('മലയാളം (Malayalam)'),
                onTap: () {
                  setState(() {
                    widget.selectedLanguage = 'ml-IN';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('ଓଡ଼ିଆ (Odia)'),
                onTap: () {
                  setState(() {
                    widget.selectedLanguage = 'or-IN';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Sign up method
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Verify passwords match
      if (_passwordController.text != _confirmPasswordController.text) {
        throw Exception('Passwords do not match');
      }

      // Make the actual API call
      final response = await http
          .post(
        Uri.parse('https://sih-pravaah.onrender.com/api/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'username': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Connection timed out. Please try again.');
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (mounted) {
          // Save user data
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userEmail', responseData['user']['email']);
          await prefs.setString('userName', responseData['user']['username']);
          await prefs.setString('userToken', responseData['token']);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          Navigator.pop(
              context, true); // Return true to indicate successful signup
        }
      } else {
        setState(() {
          _errorMessage = responseData['message'] ??
              'Registration failed: ${response.statusCode}';
        });
      }
    } on TimeoutException catch (_) {
      setState(() {
        _errorMessage =
            'Connection timed out. Please check your internet connection.';
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final translation = translations[widget.selectedLanguage]!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF4B5EFC),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up, color: Color(0xFF4B5EFC)),
            onPressed: () => _speak(translation['signUpTitle']!),
          ),
          IconButton(
            icon: const Icon(Icons.language, color: Color(0xFF4B5EFC)),
            onPressed: () => _showLanguageDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 80,
                    color: Color(0xFF4B5EFC),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    translation['signUpTitle']!,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B5EFC),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Name field
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(
                      color: Color(0xFF4B5EFC),
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      labelText: translation['name']!,
                      labelStyle: const TextStyle(color: Color(0xFF4B5EFC)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: const Color(0xFF4B5EFC).withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                            color: Color(0xFF4B5EFC), width: 2),
                      ),
                      prefixIcon: const Icon(Icons.person, color: Color(0xFF4B5EFC)),
                      filled: true,
                      fillColor: const Color(0xFF4B5EFC).withOpacity(0.05),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Email field
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(
                      color: Color(0xFF4B5EFC),
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      labelText: translation['emailAddress']!,
                      labelStyle: const TextStyle(color: Color(0xFF4B5EFC)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                            color: const Color(0xFF4B5EFC).withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                            color: Color(0xFF4B5EFC), width: 2),
                      ),
                      prefixIcon:
                          const Icon(Icons.email, color: Color(0xFF4B5EFC)),
                      filled: true,
                      fillColor: const Color(0xFF4B5EFC).withOpacity(0.05),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Password fields with visibility toggles
                  buildPasswordField(
                    controller: _passwordController,
                    isVisible: _passwordVisible,
                    onVisibilityChanged: () =>
                        setState(() => _passwordVisible = !_passwordVisible),
                    label: translation['password']!,
                  ),
                  const SizedBox(height: 20),
                  buildPasswordField(
                    controller: _confirmPasswordController,
                    isVisible: _confirmPasswordVisible,
                    onVisibilityChanged: () => setState(() =>
                        _confirmPasswordVisible = !_confirmPasswordVisible),
                    label: translation['confirmPassword']!,
                  ),
                  const SizedBox(height: 32),
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B5EFC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              translation['confirm']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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

  Future signIn() async {
    await GoogleSignInApi.login(); 
  }

  // Helper method to build password fields
  Widget buildPasswordField({
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onVisibilityChanged,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      style: const TextStyle(
        color: Color(0xFF4B5EFC),
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF4B5EFC)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide:
              BorderSide(color: const Color(0xFF4B5EFC).withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF4B5EFC), width: 2),
        ),
        prefixIcon: const Icon(Icons.lock, color: Color(0xFF4B5EFC)),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFF4B5EFC),
          ),
          onPressed: onVisibilityChanged,
        ),
        filled: true,
        fillColor: const Color(0xFF4B5EFC).withOpacity(0.05),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn(
    clientId: 'YOUR_WEB_CLIENT_ID_HERE', // Add this for web
    scopes: ['email', 'profile'],
  );
  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
}

class ForgotPasswordPage extends StatefulWidget {
  final String selectedLanguage;

  const ForgotPasswordPage({
    super.key,
    required this.selectedLanguage,
  });

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String _message = '';
  bool _isError = false;
  bool _isSuccess = false;

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _message = '';
      _isError = false;
      _isSuccess = false;
    });

    try {
      final response = await http.post(
        Uri.parse('https://sih-pravaah.onrender.com/api/auth/forgot-password'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': _emailController.text,
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Connection timed out. Please try again.');
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _isSuccess = true;
          _message = 'Password reset email sent successfully! Please check your email (including spam folder) and follow the instructions to reset your password.';
        });
      } else {
        setState(() {
          _isError = true;
          _message = responseData['message'] ?? 'An error occurred. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _isError = true;
        _message = 'Network error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final translation = translations[widget.selectedLanguage]!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4B5EFC)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          translation['forgotPassword']!,
          style: const TextStyle(color: Color(0xFF4B5EFC)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.lock_reset,
                  size: 80,
                  color: Color(0xFF4B5EFC),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Enter your email address and we\'ll send you instructions to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: Color(0xFF4B5EFC),
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: translation['emailAddress']!,
                    labelStyle: const TextStyle(color: Color(0xFF4B5EFC)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: const Color(0xFF4B5EFC).withOpacity(0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Color(0xFF4B5EFC),
                        width: 2,
                      ),
                    ),
                    prefixIcon: const Icon(Icons.email, color: Color(0xFF4B5EFC)),
                    filled: true,
                    fillColor: const Color(0xFF4B5EFC).withOpacity(0.05),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                if (_message.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _message,
                      style: TextStyle(
                        color: _isError ? Colors.red : Colors.green,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendResetEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B5EFC),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Send Reset Email',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                if (_isSuccess) ...[
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back to login page
                    },
                    child: const Text(
                      'Return to Login',
                      style: TextStyle(
                        color: Color(0xFF4B5EFC),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                const Text(
                  'Note: If you don\'t receive the email within a few minutes, please check your spam folder or try resending the email.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
