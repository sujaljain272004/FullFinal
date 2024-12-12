import 'dart:io';
import 'dart:async'; // Add this import at the top with other imports

import 'package:flutter/material.dart' hide Material;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:railway_navigation_app/webview_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_cube/flutter_cube.dart' hide Material;
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'pnr_status_page.dart';
import 'train_search_page.dart';
import 'train_status_page.dart';
import 'package:flutter/material.dart' as flutter_material show Material;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'map_screen.dart';
import 'dart:math' show Random;
import 'package:permission_handler/permission_handler.dart';
import 'maitreyee.dart';
import 'kolhapur_station.dart';

class LocalizationService {
  static final Map<String, Map<String, String>> _localizedStrings = {
    'English': {
      'welcome': 'Welcome',
      'namaste': 'Namaste',
      'select_station': 'Find Your Station',
      'start_navigation': 'Navigate Now',
      'navigation_started': 'Navigation Started',
      'view_3d_model': 'Interactive 3D Map',
      'welcome_message':
          'Welcome to Railway Navigation App. Select your station to start.',
      'pnr': 'PNR',
      'location': 'Location',
      'name': 'Name',
      'holiday_package': 'Holiday Package',
      'explore_india': 'Explore India by Train',
      'special_offers': 'Special Offers',
      'first_booking_off': '50% Off on First Booking',
      'irctc_food': 'IRCTC Food',
      'order_food': 'Order Food to Your Seat',
      'premium_lounges': 'Premium Lounges',
      'access_lounges': 'Access Railway Lounges',
      'travel_insurance': 'Travel Insurance',
      'safe_journey': 'Safe Journey Guaranteed',
      'tourist_packages': 'Tourist Packages',
      'explore_heritage': 'Explore Heritage Sites',
      'static_navigation': 'Blind Assist',
      'ar_view': 'AR Navigation',
      'navigate_smarter_travel': 'Navigate Smarter, Travel Better!',
      'track_train_status': 'Track your Train Status',
      'track_pnr_status': 'Track your PNR Status',
      'find_train_location': 'Find Train Location',
      'search_trains': 'Search Trains by Name',
    },
    'हिंदी (Hindi)': {
      'welcome': 'स्वागत है',
      'namaste': 'नमस्ते',
      'select_station': 'स्टेशन चुनें',
      'start_navigation': 'नेविगेशन शुरू करें',
      'navigation_started': 'नेविगेशन शुरू हुआ',
      'view_3d_model': '3D मॉडल देखें',
      'welcome_message':
          'रेलवे नेविगेशन ऐप में आपका स्वागत है। शुरू करने क    लिए अपना स्टेशन चुनें।',
      'pnr': 'पीएनआर',
      'location': 'स्थान',
      'name': 'नाम',
      'holiday_package': 'छुट्टी का पैकेज',
      'explore_india': 'ट्रेन से भारत की खोज करें',
      'special_offers': 'विशेष ऑफर',
      'first_booking_off': 'पहली बुकिंग पर 50% छूट',
      'irctc_food': 'आईआरसीटीसी भोजन',
      'order_food': 'अपनी सीट पर भोज   ऑर्डर करें',
      'premium_lounges': 'प्रीमियम लाउंज',
      'access_lounges': 'रेलवे लाउंज एक्सेस करें',
      'travel_insurance': 'यात्रा बीमा',
      'safe_journey': 'सुरक्षित यात्रा की गारंटी',
      'tourist_packages': 'पर्यटक पैकेज',
      'explore_heritage': 'विरासत स्थलों की खोज करें',
      'static_navigation': 'दृष्टिबाधित मित्र नेविगेशन',
      'ar_view': 'एआर व्यू',
      'navigate_smarter_travel': 'नेविगेट स्मार्टर, ट्रावल बेटर!',
      'track_train_status': 'अपनी ट्रेन की स्थिति जानें',
      'track_pnr_status': 'अपनी पीएनआर स्थिति जानें',
      'find_train_location': 'ट्रेन का स्थान खोजें',
      'search_trains': 'नाम से ट्रेन खोजें',
    },
    'मराठी (Marathi)': {
      'welcome': 'स्वागत आहे',
      'namaste': 'नमस्क  र',
      'select_station': 'स्टेशन निवडा',
      'start_navigation': 'नेव्हिगेशन सुरू करा',
      'navigation_started': 'नेव्हिगेशन सुरू झाले',
      'view_3d_model': '3D मॉडेल पहा',
      'welcome_message':
          'रेल्वे नेव्हिगेशन अॅपमध्ये तुमचे स्वागत आहे. सुरू करण्यासाठी तुमच स्टेशन निवडा.',
      'pnr': 'पीएनआर',
      'location': 'स्थान',
      'name': 'नाव',
      'holiday_package': 'सुट्टी पॅकेज',
      'explore_india': 'ट्रेनने भारत एक्सप्लोर करा',
      'special_offers': 'खास ऑफर',
      'first_booking_off': 'पहिल्या बुकिंगवर ५०% सूट',
      'irctc_food': 'आयआरसीट   सी जेवण',
      'order_food': 'तुमच्या सीटवर जेवण मागवा',
      'premium_lounges': 'प्रीमियम लाउंज',
      'access_lounges': 'रेल्वे लाउंज वापरा',
      'travel_insurance': 'प्रवास विमा',
      'safe_journey': 'सुरक्षित प्रवासाची हमी',
      'tourist_packages': 'पर्यटन पॅकेज',
      'explore_heritage': 'वारसा स्थळे एक्सप्लोर करा',
      'static_navigation': 'दृष्टिबाधित मित्र नेविगेशन',
      'ar_view': 'एआर व्यू',
      'navigate_smarter_travel': 'नेविगेट स्मार्टर, ट्रावल बेटर!',
      'track_train_status': 'आपल्या ट्रेनची स्थिती तपासा',
      'track_pnr_status': 'आपली पीएनआर स्थिती तपासा',
      'find_train_location': 'ट्रेनचे स्थान शोधा',
      'search_trains': 'नावाने ट्रेन शोधा',
    },
    'தமிழ் (Tamil)': {
      'welcome': 'வரவேற்கிறோம்',
      'namaste': 'வணக்கம்',
      'select_station': 'நிலையத்தைத் தேர்ந்தெடுக்கவும்',
      'start_navigation': 'வழிகாட்டியை தொடங்கவும்',
      'navigation_started': '���ழிக��ட்டி தொடங்கப்பட்டது',
      'view_3d_model': '3D மாதிரியை காண்க',
      'welcome_message':
          'ரயில் வழிகாட்டு செயலியில் உங்களை வரவேற்கிறோம். தொடங்க உங்கள் நிலையத்தைத் தேர்ந்தெடுக்கவும்.',
      'pnr': 'பிஎன்ஆர்',
      'location': 'இடம்',
      'name': 'பெயர்',
      'holiday_package': 'விடுமுறை தொகுப்பு',
      'explore_india': 'ரயில் மூலம் இந்தியாவை ஆராயுங்கள்',
      'special_offers': 'சிறப்பு சலுகை   ள்',
      'first_booking_off': 'முதல் முறை முன்பதிவில் 50% தள்ளுபடி',
      'irctc_food': 'ஐஆர்சிடிசி உணவு',
      'order_food': 'உங்கள் இருக்கைக்கு உணவு ஆர்டர் செய்யுங்கள்',
      'premium_lounges': 'பிரீமியம் லவுஞ்ச்',
      'access_lounges': 'ரயில்வே லౌஞ்ச் அணுகல்',
      'travel_insurance': 'பயண காப்பீடு',
      'safe_journey': 'பாதுகாப்பான பயணம் உறுதி',
      'tourist_packages': 'சுற்றுலா தொகுப்புகள்',
      'explore_heritage': 'பாரம்பரிய தளங  களை ஆராயுங்கள்',
      'static_navigation': 'தூரம் வழிகாட்டு',
      'ar_view': 'ஏஆர் வ்யூ',
      'navigate_smarter_travel': 'நேவிக்கு சிறந்தது, பயணம் சிறந்தது!',
      'track_train_status': 'உங்கள் ரயில் நிலையைக் கண்காணிக்கவும்',
      'track_pnr_status': 'உங்கள் பிஎன்ஆர் நிலையைக் கண்காணிக்கவும்',
      'find_train_location': 'ரயில் இருப்பிடத்தைக் கண்டறியவும்',
      'search_trains': 'பெயரால் ரயில்களைத் தேடுங்கள்',
    },
    'తెలుగు (Telugu)': {
      'welcome': 'స్వాగతం',
      'namaste': 'నమస్కారం',
      'select_station': 'స్టేష  ్‌ను ఎంచుకోండి',
      'start_navigation': 'నావిగేషన్‌ను ప్రారంభించండి',
      'navigation_started': 'నావిగేషన్ ప్రారంభమైంది',
      'view_3d_model': '3D మోడల్ చూడండి',
      'welcome_message':
          'రైల్వే నావిగేషన్ యాప్‌కి స్వాగతం. ప్రారంభించడానికి మీ స్టేషన్‌ను ఎంచుకోండి.',
      'pnr': 'పీఎన్ఆర్',
      'location': 'స్థానం',
      'name': 'పేరు',
      'holiday_package': 'సెలవు ప్యాకేజీ',
      'explore_india': 'రైలు ద్వారా భారతదేశాన్ని అన్వేషించండి',
      'special_offers': 'ప్రత్యేక ఆఫర్లు',
      'first_booking_off': 'మొదటి బుకింగ్‌పై 50% తగ్గింపు',
      'irctc_food': 'ఐఆర్సీటీసీ ఆహారం',
      'order_food': 'మీ సీటుకు ఆహారం ఆర్డర్ చేయండి',
      'premium_lounges': 'ప్రీమియం లౌంజ్‌లు',
      'access_lounges': 'రైల్వే లౌంజ్‌లను యాక్సెస్ చేయండి',
      'travel_insurance': 'ప్రయాణ బీమా',
      'safe_journey': 'సురక్షిత ప్రయాణ ఖాతరి',
      'tourist_packages': 'ప     వాసి ప್యాకೇజ್‌గళು',
      'explore_heritage': 'వారసత్వ ప్రదేశాలను అన్వేషించండి',
      'static_navigation': 'దృష్టిబాధిత మిత్ర నావిగేషన్',
      'ar_view': 'ఏఆర్ వ్యూ',
      'navigate_smarter_travel': 'నేవిగేట్ స్మార్టర్, ట్రావెల్ బెటర್!',
      'track_train_status': 'మీ రైలు స్థితిని ట్రాక్ చేయండి',
      'track_pnr_status': 'మీ PNR స్థితిని ట్రాక్ చేయండి',
      'find_train_location': 'రైలు స్థానాన్ని కనుగొనండి',
      'search_trains': 'పేరు ద్వారా రైళ్లను శోధించండి',
    },
    'বাংলা (Bengali)': {
      'welcome': 'স্বাগত',
      'namaste': 'নমস্কার',
      'select_station': 'স্টেশন নির্বাচন করুন',
      'start_navigation': 'নেভিগেশন শুরু করুন',
      'navigation_started': 'নেভিগেশন শুরু হয়েছে',
      'view_3d_model': '3D মডেল দেখুন',
      'welcome_message':
          'রেলওয়ে নেভিগেশন অ্যাপে আপনাকে স্বাগত। শুরু করতে আপনার স্টেশন নির্বাচন করুন।',
      'pnr': 'পিএনআর',
      'location': 'অবস্থান',
      'name': 'নাম',
      'holiday_package': 'ছুটির প্যাকেজ',
      'explore_india': 'ট্রেনে করে ভারত ভ্রমণ করুন',
      'special_offers': 'স্পেশাল অফার',
      'first_booking_off': 'প্রথম বুকিংয়ে ৫০% ছাড়',
      'irctc_food': 'আইআরসিটিসি খাবার',
      'order_food': 'আপনার সিটে খাবার অর্ডার করুন',
      'premium_lounges': 'প্রিমিয়াম লাউঞ্জ',
      'access_lounges': 'রেলওয়ে লাউঞ্জ ব্যবহার করুন',
      'travel_insurance': 'ভ্রমণ বীমা',
      'safe_journey': 'নিরাপদ যাত্রার গ্যারান্টি',
      'tourist_packages': 'পর্যটন প্যাকেজ',
      'explore_heritage': 'ঐতিহ্ୟ স্থান ভ্রমণ করুন',
      'static_navigation': 'দৃষ্টিবাধিত মিত্র নেভিগেশন',
      'ar_view': 'এআর দেখান',
      'navigate_smarter_travel': 'নেভিগেশন স্মার্টার, ট্রাভেল বেটার!',
      'track_train_status': 'আপনার ট্রেনের স্থিতি ট্র্যাক করুন',
      'track_pnr_status': 'আপনার পিএনআর স্থিতি ট্র্যাক করুন',
      'find_train_location': 'ট্রেনের অবস্থান খুঁজুন',
      'search_trains': 'নাম দ্বারা ট্রেন খুঁজুন',
    },
    'ગુજરાતી (Gujarati)': {
      'welcome': 'સ્વાગત છે',
      'namaste': 'નમસ્���������ે',
      'select_station': 'સ્ટ�����શન પસંદ કરો',
      'start_navigation': 'નેવિગેશન શરૂ કરો',
      'navigation_started': 'નેવિગેશન શરૂ થયું',
      'view_3d_model': '3D મોડલ જુ���',
      'welcome_message':
          'રેલવે નેવિગેશન એપમાં તમારું સ્વાગત છે. શરૂ કરવા માટે તમારું સ્ટેશન પસંદ કરો.',
      'pnr': 'પીએનઆર',
      'location': 'સ્થાન',
      'name': 'નામ',
      'holiday_package': 'હોલિડે પેકેજ',
      'explore_india': 'ટ્���ેન દ્વારા ભારતની સફર કરો',
      'special_offers': 'સ્પેશિયલ ઓફર',
      'first_booking_off': 'પ્રથમ બુકિંગ પર ૫૦% ડિસ્કાઉન્ટ',
      'irctc_food': 'આઈઆરસીટીસી ફૂડ',
      'order_food': 'તમારી સીટ પર ખોરાક મંગાો',
      'premium_lounges': 'પ્રીમિયમ લાઉન્જ',
      'access_lounges': 'રેલવે લાઉન્જનો ઉપયોગ કરો',
      'travel_insurance': 'મુસાફરી વીમો',
      'safe_journey': 'સુરક્ષિત    ુસાફરીની ગેરંટી',
      'tourist_packages': 'પ્રવાસન પેકેજ',
      'explore_heritage': 'વારસાગત સ્થળોની મુલાકાત લો',
      'static_navigation': 'દૃષ્ટિબાધિત મિત્ર નેવિગેશન',
      'ar_view': 'એઆર વ્યૂ',
      'navigate_smarter_travel': 'નેવિગેટ સ્માર્ટર, ટ્રાવેલ બેટર!',
      'track_train_status': 'તમારી ટ્રેનની ���   થિતિ ટ્રૅક કરો',
      'track_pnr_status': 'તમારી PNR સ્થિતિ ટ્રૅક કરો',
      'find_train_location': 'ટ્રેનનું સ્થાન શોધો',
      'search_trains': 'નામ દ્વારા ટ્રેન શોધો',
    },
    'ਪੰਜਾਬੀ (Punjabi)': {
      'welcome': "ਸਵਾਗਤ ਹੈ",
      'namaste': "ਸਤਿ ਸ੍ਰੀ ਅਕਾਲ",
      'select_station': "ਸਟੇਸ਼ਨ ਚਣੋ",
      'start_navigation': "ਨੇਵੀਗੇਸ਼ਨ ਸ਼ੁਰੂ ਕਰੋ",
      'navigation_started': "ਨੇਵੀਗੇਸ਼ਨ ਸ਼ੁਰੂ ਹੋ ਗਿਆ ਹੈ",
      'view_3d_model': "3D ਮਾਡਲ ਵੇਖੋ",
      'welcome_message':
          "ਰੇਲਵੇ ਨੇਵੀਗੇਸ਼ਨ ਐਪ ਵਿੱਚ ਤੁਹਾਡਾ ਸਵਾਗਤ ਹੈ। ਸ਼ੁਰੂ ਕਰਨ ਲਈ ਆਪਣਾ ਸਟੇਸ਼ਨ ਚੁਣੋ",
      'pnr': "ਪੀਐਨਆਰ",
      'location': "ਸਥਾਨनन",
      'name': "ਨਾਮ",
      'holiday_package': "ਛੁੱਟੀਆਂ ਦਾ ਪੈਕੇਜ",
      'explore_india': "ਰੇਲ ਗੱਡੀ ਰਾਹੀਂ ਭਾਰਤ ਦੀ ਖੋਜ ਕਰੋ",
      'special_offers': "ਵਿਸ਼ੇਸ਼ ਪ   ਸ਼ਕਸ਼ਾਂ",
      'first_booking_off': "ਪਹਿਲੀ ਬੁਕਿੰਗ ਤੇ 50% ਛੂਟ",
      'irctc_food': "ਆਈਆਰਸੀਟੀਸੀ ਭੋਜਨ",
      'order_food': "ਆਪਣੀ ਸੀਟ ਤੇ ਭੋਜਨ ਆਰਡਰ ਕରନ୍ତୁ",
      'premium_lounges': "ਪ੍ਰੀਮੀਅਮ ਲਾਊਂਜ",
      'access_lounges': "ਰੇਲਵੇ ਲਾଊਂਜ ଐରନ୍ତୁ",
      'travel_insurance': "ਯਾਤਰਾ ਬੀਮਾ",
      'safe_journey': "ੁਰੱਖਿਅਤ ਯਾਤਰਾ ਦੀ ਗਾਰੰਟੀ",
      'tourist_packages': "ਸੈ-ਸਾਟਾ ਕੇਜ",
      'explore_heritage': "ਵਿਰਾਸਤੀ ਥਾਵਾਂ ਦੀ ਖਜ ਕਰੋ",
      'static_navigation': 'ਨਰਿਸ਼ਤੀਬਾਧਿਤ ਮਿਤਰ ਨੇਵੀਗੇਸ਼ਨ',
      'ar_view': 'ਏਆਰ ਵ੍ਯੂ',
      'navigate_smarter_travel': 'ਨੇਵੀਗੇਸ਼ਨ ਸਮਾਰਭਰ, ਟ੍ରਾଵੇଲ ବେଟର୍!',
      'track_train_status': 'ਆਪਣੀ ਰੇਲ ਗੱਡੀ ਦੀ ਸਥਿਤੀ ଟਰੈਕ କରନ୍ତୁ',
      'track_pnr_status': 'ଆਪਣੀ PNR ସ୍ଥିତି ଟ୍ରାକ୍ କରନ୍ତୁ',
      'find_train_location': 'ରੇਲ ଗੱਡੀ ଦਾ ସଥାନ ଖୋଜନ୍ତୁ',
      'search_trains': 'ନାମ ଦ୍ଵାରା ଟ୍ରାଇନ୍ ସ୍ଥାନ ଖୋଜନ୍ତୁ',
    },
    'ಕನ್ನಡ (Kannada)': {
      'welcome': 'ಸ್ವಾಗತ',
      'namaste': 'ನಮಸ್ಕಾರ',
      'select_station': 'ನಿಲ್ದಾಣವನ            ಆಯ್ಕೆಮಾಡಿ',
      'start_navigation': 'ನಾವಿಗೇಶನ್ ಪ್ರಾರಂಭಿಸಿ',
      'navigation_started': 'ನಾವಿ    ಶನ್ ಪ್ರಾರಂಭವಾಯಿತು',
      'view_3d_model': '3D ಮಾದರಿಯನ್ನ   ವ        ್     ಸಿ',
      'welcome_message':
          '            ಲು ನಾವಿಗೇಶನ್ ಅಪ್ಲಿಕೇಶನ್‌ಗೆ ಸ್ವಾಗತ. ಪ್ರಾ  ಂಭಿಸಲು ನಿಮ್ಮ ನಿಲ್ದಾಣವನ್ನು ಆಯ್ಕೆಮಾಡಿ.',
      'pnr': 'ಪಿಎನ   ‌ಆ   ್',
      'location': 'ಸ್ಥ  ',
      'name': 'ಹೆಸರು',
      'holiday_package': 'ರಜಾ ಪ್ಯಾಕೇಜ್',
      'explore_india': 'ರೈಲಿನಲ್ಲಿ ಭ   ರತವನ್ನು ಅನ್ವೇಷಿಸಿ',
      'special_offers': 'ವಿಶೇಷ ಕೊಡುಗೆಗಳು',
      'first_booking_off': 'ಮೊದಲ ಬುಕ್ಕಿಂಗ್‌ನಲ್ಲಿ 50% ರಿಯಾಯಿತಿ',
      'irctc_food': 'ಐಆರ್‌ಸಿಟಿಸಿ ಆಹಾರ',
      'order_food': 'ನಿಮ್ಮ ಸೀಟ್‌ಗೆ ಆಹಾರ ಆರ್ಡರ್ ಮಾಡಿ',
      'premium_lounges': 'ಪ್ರೀಮಿಯಂ ಲೌಂಜ್‌ಗಳು',
      'access_lounges': 'ರೈಲ್ವೇ ಲೌಂಜ್‌ಗಳನ್ನು ಪ್ರವೇಶಿಸಿ',
      'travel_insurance': 'ಪ್ರಯಾಣ ವಿಮೆ',
      'safe_journey': 'ಸುರಕ್ಷಿತ ಪ್ರಯಾಣ ಖಾತರಿ',
      'tourist_packages': 'ಪ     ವಾಸಿ ಪ್ಯಾಕೇಜ್‌ಗಳು',
      'explore_heritage': 'ಪರಂಪರೆಯ ಸ್ಥಳಗಳನ್ನು ಅನ್ವೇಷಿಸಿ',
      'static_navigation': 'ದೃಷ್ಟಿಬಾಧಿತ ಮಿತ್ರ ನಾವಿಗೇಶನ್',
      'ar_view': 'ಏಆರ್ ವ್ಯೂ',
      'navigate_smarter_travel': 'ನೇವಿಗೇಶನ್ ಸ್ಮಾರ್ಟರ್, ಟ್ರಾವೆಲ್ ಬೆಟ್ಟರ್!',
      'track_train_status': 'ನಿಮ್ಮ ರೈಲು ಸ್ಥಿತಿಯನ್ನು ಟ್ರ್ಯಾಕ್ ಮಾಡಿ',
      'track_pnr_status': 'ನಿಮ್ಮ PNR ಸ್ಥಿತಿಯನ್ನು ಟ್ರ್ಯಾಕ್ ಮಾಡಿ',
      'find_train_location': 'ರೈಲಿನ ಸ್ಥಳವನ್ನು ಹುಡುಕಿ',
      'search_trains': 'ಹೆಸರಿನಿಂದ ರೈಲುಗಳನ್ನು ಹುಡುಕಿ',
    },
    'മലയാളം (Malayalam)': {
      'welcome': 'സ്വാഗതം',
      'namaste': 'നമസ്കാരം',
      'select_station': 'സ്റ്റേഷൻ തിരഞ്ഞെടുക്കുക',
      'start_navigation': 'നാവിഗേഷൻ ആരംഭിക്കുക',
      'navigation_started': 'നാവിഗേഷൻ ആരംഭിച്ചു',
      'view_3d_model': '3D മോഡൽ കാണുക',
      'welcome_message':
          'റെയിൽവേ നാവിഗേഷൻ ആപ്പിലേക്ക് സ്വാഗതം. ആരംഭിക്കാൻ നിങ്ങളുടെ സ്റ്റേഷൻ തിരഞ്ഞെടുക്കുക.',
      'pnr': 'പിഎൻആർ',
      'location': 'സ്ഥലം',
      'name': 'പേര്',
      'holiday_package': 'അവധിക്കാല പാക്കേജ്',
      'explore_india': 'ട്രെയിനിലൂടെ ഇന്ത്യ കണ്ടെത്തൂ',
      'special_offers': '  ്രത്യേക ഓഫറുകൾ',
      'first_booking_off': 'ആദ്യ ���ുക്കിംഗിന് 50% കിഴിവ്',
      'irctc_food': 'ഐആർർ്‍സിടിസി ഭക്ഷണം',
      'order_food': 'നിങ്ങളുടെ സീറ്റിലേക്ക് ഭക്ഷണം ഓർഡർ ചെയ്യൂ',
      'premium_lounges': 'പ്രീമിയം ലോഞ്ചുകൾ',
      'access_lounges': 'റെയിൽവേ ലോഞ്ചുകൾ ആക്സസ് ചെയ്യൂ',
      'travel_insurance': 'യാത്രാ ഇൻഷുറൻസ്',
      'safe_journey': 'സുരക്ഷിത യാത്ര ഉറപ്പ്',
      'tourist_packages': 'ടൂറിസ്റ്റ് പാക്കേജുകൾ',
      'explore_heritage': 'പൈതൃക സ്ഥല്ങൾ കണ്ടെത്തൂ',
      'static_navigation': 'നൃഷ്ടിബാധിത മിത്ര നാവിഗേഷൻ',
      'ar_view': 'ഏആര് വ്യൂ',
      'navigate_smarter_travel': 'നേവിഗേഷൻ സ്മാര്ട്ടർ, ട്രാവെല് ബെട്ടർ!',
      'track_train_status': 'നിങ്ങളുടെ ട്രെയിൻ സ്റ്റാറ്റസ് ട്രാക്ക് ചെയ്യുക',
      'track_pnr_status': 'നിങ്ങളുടെ PNR സ്റ്റാറ്റസ് ട്രാക്ക് ചെയ്യുക',
      'find_train_location': 'ട്രെയിൻ ലൊക്കേഷൻ കണ്ടെത്തുക',
      'search_trains': 'പേര് ഉപയോഗിച്ച് ട്രെയിനുകൾ തിരയുക',
    },
    'ଓଡ଼ିଆ (Odia)': {
      'welcome': 'ସ୍ୱାଗତ',
      'namaste': 'ନମସ୍କାର',
      'select_station': 'ସ୍ଟେସନ୍ ବାଛନ୍ତୁ',
      'start_navigation': 'ନେଭିଗେସନ୍ ଆରମ୍ଭ କରନ୍ତୁ',
      'navigation_started': 'ନେଭିଗେସ  ୍ ଆରମ୍ଭ ହେଲା',
      'view_3d_model': '3D ମୋଡେଲ୍ ଦେଖନ୍ତୁ',
      'welcome_message':
          'ରେଲୱେ ନେଭିଗେସନ୍ ଆପ୍ରେ ଆପଣଙ୍କୁ ସ୍ୱାଗତ। ଆରମ୍ଭ କରିବାକୁ ଆପଣଙ୍କର ସ୍ଟେସନ୍ ବାଛନ୍ତୁ',
      'pnr': 'ପିଏନଆର',
      'location': 'ସ୍ଥାନ',
      'name': 'ନାମ',
      'holiday_package': 'ଛୁଟି ପ୍ୟାକେଜ',
      'explore_india': 'ଟ୍ରେନରେ ଭାରତ ଭ୍ରମଣ କରନ୍ତୁ',
      'special_offers': 'ବିଶେଷ ଅଫର',
      'first_booking_off': 'ପ୍ରଥମ ବୁକିଂରେ ୫୦% ଛାଡ଼',
      'irctc_food': 'ଆଇଆରସିଟିସି ଖାଦ୍ୟ',
      'order_food': 'ଆପଣଙ୍କ ସିଟକୁ ଖାଦ୍ୟ ଅର୍ଡର କରନ୍ତୁ',
      'premium_lounges': 'ପ୍ରିମିୟମ ଲାଉଞ୍ଜ',
      'access_lounges': 'ରେଳବାଇ ଲାଉଞ୍ଜ ଆକ୍ସେସ କରନ୍ତୁ',
      'travel_insurance': 'ଯାତ୍ରା ବୀମା',
      'safe_journey': 'ସୁରକ୍ଷିତ ଯାତ୍ରାର ଗ୍ୟାରେଣ୍ଟି',
      'tourist_packages': 'ପର୍ଯ୍ୟଟନ ପ୍ୟାକେଜ',
      'explore_heritage': 'ଐତିହ୍ୟ ସ୍ଥଳୀ ଭ୍ରମଣ କରନ୍ତୁ',
      'static_navigation': 'ନୃଷ୍ଟିବାଧିତ ମିତ୍ର ��େଭିଗେସନ',
      'ar_view': 'ଏଆର ଵ୍ଯୂ',
      'navigate_smarter_travel': 'ନେଭିଗେସନ୍ ସ୍ମାର୍ଟର୍, ଟ୍ରାଵେଲ୍ ବେଟର୍!',
      'track_train_status': 'ନିମ୍ନ ଟ୍ରାଇନ୍ ସ୍ଥିତି ଟ୍ରାକ୍ କରନ୍ତୁ',
      'track_pnr_status': 'ନିମ୍ନ PNR ସ୍ଥିତି ���୍ରାକ୍ କରନ୍ତୁ',
      'find_train_location': 'ଟ୍ରାଇନ୍ ଲୋକେସନ୍ ସ୍ଥାନ ଖୋଜନ୍ତୁ',
      'search_trains': 'ନାମ ଦ୍ଵାରା ଟ୍ରାଇନ୍ ସ୍ଥାନ ଖୋଜନ୍ତୁ',
    },
  };

  static String _currentLanguage = 'English';

  static Future<void> loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('selected_language') ?? 'English';
  }

  static Future<void> setLanguage(String language) async {
    _currentLanguage = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', language);
  }

  static String translate(String key) {
    return _localizedStrings[_currentLanguage]?[key] ?? key;
  }

  static String get currentLanguage => _currentLanguage;
}

// Welcome Page
// Welcome Page
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key, required String username});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  final int _currentIndex = 0;
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _searchText = '';
  final bool _isChatbotVisible = false;
  final List<String> _stationSuggestions = [
    'Pune Station',
    'Pune Junction',
    'Pune Cantonment',
    'Puntamba',
    'Punkunnam',
    'Puntang',
    // Add more station names here
  ];
  List<String> _filteredStations = [];
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> advertisements = [
    {
      'titleKey': 'holiday_package',
      'subtitleKey': 'explore_india',
      'color': const Color(0xFF4B5EFC),
    },
    {
      'titleKey': 'special_offers',
      'subtitleKey': 'first_booking_off',
      'color': const Color(0xFF2196F3),
    },
    {
      'titleKey': 'irctc_food',
      'subtitleKey': 'order_food',
      'color': const Color(0xFFFF5722),
    },
    {
      'titleKey': 'premium_lounges',
      'subtitleKey': 'access_lounges',
      'color': const Color(0xFF4CAF50),
    },
    {
      'titleKey': 'travel_insurance',
      'subtitleKey': 'safe_journey',
      'color': const Color(0xFF9C27B0),
    },
    {
      'titleKey': 'tourist_packages',
      'subtitleKey': 'explore_heritage',
      'color': const Color(0xFFFF9800),
    },
  ];

  // Add this to your state class variables
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    LocalizationService.loadLanguagePreference().then((_) => setState(() {}));
    _setTtsLanguage();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });

    // Setup notification timer
    _notificationTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      setState(() {
        _shouldShowNotification = true;
      });

      // Hide notification after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _shouldShowNotification = false;
          });
        }
      });
    });

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _setTtsLanguage() async {
    String ttsLanguage = _getTtsLanguage();
    await _flutterTts.setLanguage(ttsLanguage);
  }

  String _getTtsLanguage() {
    switch (LocalizationService.currentLanguage) {
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

  void _readAloud(String key) async {
    _setTtsLanguage();
    await _flutterTts.speak(LocalizationService.translate(key));
  }

  void _startListening() async {
    bool hasPermission = await _requestMicrophonePermission();
    
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microphone permission is required for voice input'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (error) {
          setState(() => _isListening = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${error.errorMsg}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );

      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(
          onResult: (result) {
            setState(() {
              _searchController.text = result.recognizedWords;
              if (result.finalResult) {
                _isListening = false;
              }
            });
          },
          localeId: _getSpeechLanguage(),
        );
      }
    }
  }

  void _stopListening() {
    _speechToText.stop();
    setState(() => _isListening = false);
  }

  Widget _buildCircularButton(String labelKey, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Color(0xFFF1F3FF), // Light blue background
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: const Color(0xFF4B5EFC)), // Blue icon color
            onPressed: () {
              // Handle button tap based on label
              switch (labelKey) {
                case 'PNR':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PNRStatusPage(),
                    ),
                  );
                  break;
                case 'Location':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TrainStatusPage(),
                    ),
                  );
                  break;
                case 'Name':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TrainSearchPage(),
                    ),
                  );
                  break;
              }
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          LocalizationService.translate(labelKey.toLowerCase()),
          style: const TextStyle(color: Color(0xFF4B5EFC), fontSize: 14),
        ),
      ],
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocalizationService.translate('Select Language')),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                // Add all supported languages
                _buildLanguageOption('English'),
                _buildLanguageOption('हिंदी (Hindi)'),
                _buildLanguageOption('    राठी (Marathi)'),
                _buildLanguageOption('தமி��் (Tamil)'),
                _buildLanguageOption('తెలుగు (Telugu)'),
                _buildLanguageOption('বাংলা (Bengali)'),
                _buildLanguageOption('ગુજરાતી (Gujarati)'),
                _buildLanguageOption('ਪੰਜਾਬੀ (Punjabi)'),
                _buildLanguageOption('ಕನ್ನಡ (Kannada)'),
                _buildLanguageOption('മലാാളം (Malayalam)'),
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
      onTap: () async {
        await LocalizationService.setLanguage(language);
        _setTtsLanguage();
        setState(() {});
        if (mounted) {
          Navigator.pop(context);
        }
      },
      trailing: LocalizationService.currentLanguage == language
          ? const Icon(Icons.check, color: Color(0xFF4B5EFC))
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF4B5EFC), // Set blue background for scaffold
      body: Stack(
        children: [
          Column(
            children: [
              // Top blue section
              Container(
                height: MediaQuery.of(context).size.height * 0.28,
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Stack(
                  children: [
                    // Background Image with adjusted position
                    Positioned(
                      right: -50, // Shift more to right
                      bottom: -30, // Shift more to bottom
                      width: MediaQuery.of(context).size.width *
                          0.9, // Control width
                      height: MediaQuery.of(context).size.height *
                          0.25, // Control height
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        child: Image.asset(
                          'assets/person_with_phone.png',
                          fit: BoxFit.contain,
                          alignment:
                              Alignment.bottomRight, // Align to bottom right
                          opacity: const AlwaysStoppedAnimation(0.4),
                        ),
                      ),
                    ),

                    // Content overlay (Namaste! and buttons)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.volume_up,
                                      color: Colors.white),
                                  onPressed: () =>
                                      _readAloud('welcome_message'),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.language,
                                      color: Colors.white),
                                  onPressed: _showLanguageDialog,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Bottom white section - Expanded to fill screen
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    // Wrap content in SingleChildScrollView
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            LocalizationService.translate(
                                'navigate_smarter_travel'),
                            style: const TextStyle(
                              color: Color(0xFF4B5EFC),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Search bar
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: LocalizationService.translate(
                                    'select_station'),
                                hintStyle:
                                    const TextStyle(color: Color(0xFF4B5EFC)),
                                prefixIcon: const Icon(Icons.train,
                                    color: Color(0xFF4B5EFC)),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    if (_isListening) {
                                      _stopListening();
                                    } else {
                                      _startListening();
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Icon(
                                      _isListening ? Icons.mic : Icons.mic_none,
                                      color: _isListening ? Colors.red : const Color(0xFF4B5EFC),
                                    ),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                              style: const TextStyle(color: Color(0xFF4B5EFC)),
                              onChanged: (value) {
                                setState(() {
                                  if (value.isEmpty) {
                                    _filteredStations = [];
                                  } else {
                                    _filteredStations = _stationSuggestions
                                        .where((station) => station
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                        .toList();
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                        // Search suggestions with constrained height
                        if (_filteredStations.isNotEmpty)
                          Container(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.25,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _filteredStations.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    _filteredStations[index],
                                    style: const TextStyle(
                                        color: Color(0xFF4B5EFC)),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _searchController.text =
                                          _filteredStations[index];
                                      _searchText = '';
                                      _filteredStations = [];
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        // Add bottom padding to ensure content doesn't get hidden behind FAB
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Column(
                            children: [
                              // Search bar section (existing code)...

                              // Navigation Grid
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 32),
                                child: Column(
                                  children: [
                                    // First Row - Start Navigation & Static Navigation
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: _buildNavigationItem(
                                            icon: Icons.navigation,
                                            label: 'start_navigation',
                                            onTap: _searchController
                                                    .text.isEmpty
                                                ? null // Disable the button when no station is selected
                                                : () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            MapScreens(), // Add const and fix casing
                                                      ),
                                                    );
                                                  },
                                          ),
                                        ),
                                        const SizedBox(width: 24),
                                        Expanded(
                                          child: _buildNavigationItem(
                                            icon: Icons.accessibility_new,
                                            label: 'static_navigation',
                                            onTap: _searchController
                                                    .text.isEmpty
                                                ? null // Disable the button when no station is selected
                                                : () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            MapScreen(
                                                          selectedStation:
                                                              _searchController
                                                                  .text, // Ensure this is correctly referenced
                                                        ),
                                                      ), // Ensure this closing bracket is correct
                                                    ); // Ensure this closing bracket is correct
                                                  },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    // Second Row - 3D Model & AR View
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: _buildNavigationItem(
                                            icon: Icons.view_in_ar,
                                            label: 'view_3d_model',
                                            onTap: _searchController
                                                    .text.isEmpty
                                                ? null // Disable the button when no station is selected
                                                : () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            WebViewPage(
                                                          url:
                                                              'https://sih-3d.vercel.app/',
                                                          title: LocalizationService
                                                              .translate(
                                                                  'view_3d_model'),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                          ),
                                        ),
                                        const SizedBox(width: 24),
                                        Expanded(
                                          child: _buildNavigationItem(
                                            icon: Icons.camera,
                                            label: 'ar_view',
                                            onTap: _searchController
                                                    .text.isEmpty
                                                ? null // Disable the button when no station is selected
                                                : () async {
                                                    // First check and request camera permission
                                                    bool hasPermission =
                                                        await _requestCameraPermission();

                                                    if (!hasPermission) {
                                                      if (context.mounted) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                'Camera permission is required for AR navigation'),
                                                            backgroundColor:
                                                                Colors.red,
                                                          ),
                                                        );
                                                      }
                                                      return;
                                                    }

                                                    // Open the URL in an external browser
                                                    final url = Uri.parse(
                                                        'https://chamaat.vercel.app/');
                                                    if (!await launchUrl(url,
                                                        mode: LaunchMode
                                                            .externalApplication)) {
                                                      if (context.mounted) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                'Could not launch AR view'),
                                                            backgroundColor:
                                                                Colors.red,
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 80),
                                  ],
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
            ],
          ),
          // Services popup menu
          Positioned(
            left: 16,
            top: 40,
            child: Stack(
              children: [
                PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  offset: const Offset(0, 10),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.train,
                      color: Color(0xFF4B5EFC),
                      size: 24,
                    ),
                  ),
                  onSelected: (value) {
                    // Handle menu item selection with navigation
                    switch (value) {
                      case 'PNR':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PNRStatusPage(),
                          ),
                        );
                        break;
                      case 'Location':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TrainStatusPage(),
                          ),
                        );
                        break;
                      case 'Name':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TrainSearchPage(),
                          ),
                        );
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    _buildPopupMenuItem(
                      'PNR',
                      Icons.confirmation_number,
                      LocalizationService.translate('track_pnr_status'),
                    ),
                    _buildPopupMenuItem(
                      'Location',
                      Icons.location_on,
                      LocalizationService.translate('find_train_location'),
                    ),
                    _buildPopupMenuItem(
                      'Name',
                      Icons.train,
                      LocalizationService.translate('search_trains'),
                    ),
                  ],
                ),
                // Replace the red dot with text notification
                if (_shouldShowNotification)
                  Positioned(
                    right: -8,
                    top: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF4B5EFC),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        LocalizationService.translate('track_train_status'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Call icon button - Updated style
          Positioned(
            left: 16,
            bottom: 16,
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF4B5EFC),
                    const Color(0xFF4B5EFC).withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(27.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4B5EFC).withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: flutter_material.Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(27.5),
                  onTap: () async {
                    final Uri phoneUri = Uri.parse('tel:139');
                    try {
                      if (await canLaunchUrl(phoneUri)) {
                        await launchUrl(phoneUri);
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Could not launch emergency dialer'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error launching emergency dialer'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Animated ring
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Container(
                            width: 53 * _pulseAnimation.value,
                            height: 53 * _pulseAnimation.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white
                                    .withOpacity(1 - _pulseAnimation.value / 2),
                                width: 1,
                              ),
                            ),
                          );
                        },
                      ),
                      // Main content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.call,
                            color: Colors.red[600], // Changed to red color
                            size: 26, // Slightly larger icon
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '139',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Add chatbot button - Matching style
          Positioned(
            right: 16,
            bottom: 16,
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF4B5EFC),
                    const Color(0xFF4B5EFC).withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(27.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4B5EFC).withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: flutter_material.Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(27.5),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatbotScreen(),
                      ),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Animated ring
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Container(
                            width: 53 * _pulseAnimation.value,
                            height: 53 * _pulseAnimation.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(1 - _pulseAnimation.value / 2),
                                width: 1,
                              ),
                            ),
                          );
                        },
                      ),
                      // Main content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                            size: 26,
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Chat',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(String label, IconData iconData, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3FF),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              iconData,
              color: const Color(0xFF4B5EFC),
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF4B5EFC),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _speechToText.stop();
    _notificationTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  // Add these helper methods to your class
  PopupMenuItem<String> _buildPopupMenuItem(
      String value, IconData icon, String description) {
    return PopupMenuItem<String>(
      value: value,
      child: Container(
        constraints: const BoxConstraints(minWidth: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3FF),
                borderRadius: BorderRadius.circular(8),
              ), // Close the BoxDecoration
              child: Icon(icon,
                  color: const Color(0xFF4B5EFC),
                  size: 20), // Make child a separate property
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocalizationService.translate(value.toLowerCase()),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B5EFC),
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
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

  // Add these variables and methods to your state class
  bool _shouldShowNotification = false;
  Timer? _notificationTimer;

  get selectedStation => null;

  // Add this method to show the status tracking popup
  void _showTrackingPopup() {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: const Color(0xFF4B5EFC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Row(
          children: [
            const Icon(
              Icons.train,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Track your train status in real-time!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    final bool isEnabled = onTap != null;

    return GestureDetector(
      onTap: () {
        if (isEnabled) {
          if (label == 'start_navigation') {
            // Navigate to MapScreens when Start Navigation is clicked
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MapScreens(),
              ),
            );
          } else {
            onTap?.call();
          }
        } else {
          // Show snackbar when disabled button is tapped
          final scaffoldMessenger =
              ScaffoldMessenger.of(context); // Now context is available
          scaffoldMessenger.hideCurrentSnackBar(); // Hide any existing snackbar
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    LocalizationService.translate('select_station'),
                    style: const TextStyle(color: Colors.white),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3FF),
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF4B5EFC).withOpacity(0.1),
                    const Color(0xFFF1F3FF),
                  ],
                ),
                boxShadow: isEnabled
                    ? [
                        BoxShadow(
                          color: const Color(0xFF4B5EFC).withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.6),
                          blurRadius: 4,
                          offset: const Offset(-4, -4),
                        ),
                      ]
                    : null,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background design element
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF4B5EFC).withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  // Icon with custom design for each type
                  if (label == 'start_navigation')
                    Icon(
                      Icons.navigation,
                      color: const Color(0xFF4B5EFC),
                      size: 32,
                    )
                  else if (label == 'static_navigation')
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.accessibility_new,
                          color: const Color(0xFF4B5EFC),
                          size: 32,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Color(0xFF4B5EFC),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.hearing,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    )
                  else if (label == 'view_3d_model')
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.view_in_ar,
                          color: const Color(0xFF4B5EFC),
                          size: 32,
                        ),
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Transform.rotate(
                            angle: -0.4,
                            child: Icon(
                              Icons.view_in_ar_outlined,
                              color: const Color(0xFF4B5EFC),
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    )
                  else if (label == 'ar_view')
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.camera_enhance,
                          color: const Color(0xFF4B5EFC),
                          size: 32,
                        ),
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4B5EFC).withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.view_in_ar,
                              color: Color(0xFF4B5EFC),
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              LocalizationService.translate(label),
              style: TextStyle(
                color:
                    const Color(0xFF4B5EFC).withOpacity(isEnabled ? 1.0 : 0.5),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    return status.isGranted;
  }

  String _getSpeechLanguage() {
    switch (LocalizationService.currentLanguage) {
      case 'हिंदी (Hindi)':
        return 'hi_IN';
      case 'मराठी (Marathi)':
        return 'mr_IN';
      case 'தமிழ் (Tamil)':
        return 'ta_IN';
      case 'తెలుగు (Telugu)':
        return 'te_IN';
      case 'বাংলা (Bengali)':
        return 'bn_IN';
      case 'ગુજરાતી (Gujarati)':
        return 'gu_IN';
      case 'ਪੰਜਾਬੀ (Punjabi)':
        return 'pa_IN';
      case 'ಕನ್ನಡ (Kannada)':
        return 'kn_IN';
      case 'മലയാളം (Malayalam)':
        return 'ml_IN';
      case 'ଓଡ଼ିଆ (Odia)':
        return 'or_IN';
      default:
        return 'en_IN';
    }
  }

  Future<bool> _requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }
    return status.isGranted;
  }
}

class ModelViewerScreen extends StatefulWidget {
  const ModelViewerScreen({super.key});

  @override
  State<ModelViewerScreen> createState() => _ModelViewerScreenState();
}

class _ModelViewerScreenState extends State<ModelViewerScreen> {
  double _scale = 200.0; // Increased initial scale
  late Object _object;
  late Scene _scene;

  void _initObject() {
    _object = Object(fileName: 'assets/models/model.obj');
    _object.scale.setValues(_scale, _scale, _scale);
    _scene.world.add(_object);
  }

  void _onSceneCreated(Scene scene) {
    _scene = scene;
    _initObject();

    // Set initial camera position for better view
    _scene.camera.position.setValues(0, 0, 10);
    _scene.camera.target.setValues(0, 0, 0);
  }

  void _updateScale(double newScale) {
    setState(() {
      _scale = newScale;
      _object.scale.setValues(_scale, _scale, _scale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3D Model Viewer'),
        backgroundColor: const Color(0xFF4B5EFC),
        actions: [
          // Reset button
          IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: () {
              setState(() {
                _scale = 200.0;
                _initObject();
              });
            },
            tooltip: 'Reset View',
          ),
        ],
      ),
      body: Stack(
        children: [
          // 3D Model Viewer
          Container(
            color: Colors.white,
            child: Cube(
              onSceneCreated: _onSceneCreated,
            ),
          ),
          // Zoom controls
          Positioned(
            right: 16,
            bottom: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildZoomButton(
                  icon: Icons.add,
                  onPressed: () => _updateScale(_scale + 50),
                  tooltip: 'Zoom In',
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(_scale / 200 * 100).toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildZoomButton(
                  icon: Icons.remove,
                  onPressed: () => _updateScale(_scale - 50),
                  tooltip: 'Zoom Out',
                ),
              ],
            ),
          ),
          // Help text
          Positioned(
            left: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '• Drag to rotate',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '• Pinch to zoom',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '• Use buttons for precise zoom',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF4B5EFC),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        color: Colors.white,
        tooltip: tooltip,
      ),
    );
  }
}

enum TtsState { playing, stopped }

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  bool _isLoading = false;
  late GenerativeModel _model;
  
  // Add these two variables
  Timer? _notificationTimer;
  bool _shouldShowNotification = false;

  // Add these new variables
  final List<String> complaintCategories = [
    'Women Safety',
    'Washroom Cleanliness',
    'Food Quality',
    'Staff Behavior',
    'Train Cleanliness',
    'AC/Fan Not Working',
    'Unauthorized Vendors',
    'Delayed Trains',
    'Bedroll Quality',
    'Security Concerns',
    'Water Availability',
    'Overcrowding Issues',
    'Medical Emergency',
    'Lost Belongings',
    'Platform Facilities'
  ];

  String? selectedComplaintCategory;
  bool isRegisteringComplaint = false;

  @override
  void initState() {
    super.initState();
    _initializeChatbot();

    // Show notification every 30 seconds instead of 15
    _notificationTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        _shouldShowNotification = true;
      });
      
      // Hide notification after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _shouldShowNotification = false;
          });
        }
      });
    });
  }

  Future<void> _initializeChatbot() async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey!.isEmpty) {
      stderr.writeln('No API key found in the .env file.');
      return;
    }

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1.3,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
      systemInstruction: Content.system('You are a bot for railway , I will provide you a dataset based on that you have to answer the query \nThis is the datset on which you have to answer the queries:-\nIf someone greets you have to greet in return and ask how may I help you?\n\n1. Overview of Indian Railways\nIndian Railways is the fourth-largest railway network in the world, covering approximately 67,000 kilometers.\nOperates under the Ministry of Railways, Government of India.\nComprises 18 railway zones, including Northern Railway, Central Railway, and Southern Railway.\nServes as the primary mode of long-distance transportation for millions of passengers daily.\n2. Categories of Trains\nPassenger Trains (By Speed and Service):\nRajdhani Express: High-speed trains connecting major state capitals to New Delhi.\nFully air-conditioned (1A, 2A, 3A).\nPriority over other trains.\nShatabdi Express: High-speed intercity trains with daytime travel.\nFully air-conditioned (Executive Class, Chair Car).\nDuronto Express: Non-stop long-distance trains between major cities.\nIncludes sleeper and air-conditioned coaches.\nSuperfast Trains: Faster than regular express trains, fewer stops.\nExample: Tamil Nadu Express.\nExpress Trains: Connect major cities and towns.\nExample: Chennai Mail.\nPassenger Trains: Slower trains that stop at every station.\nExample: Local passenger trains for short distances.\nSpecial Trains\nGarib Rath: Low-cost air-conditioned trains.\nTejas Express: Premium trains with modern amenities like Wi-Fi and infotainment systems.\nFestival or Summer Specials: Operated during peak demand periods.\n3. Classes of Travel\nAir-Conditioned Classes:\nFirst Class AC (1A): Luxurious cabins with privacy and bedding.\nSecond AC (2A): Air-conditioned sleeper with 2-tier configuration.\nThird AC (3A): Air-conditioned sleeper with 3-tier configuration.\nNon-Air-Conditioned Classes:\nSleeper Class (SL): Affordable non-AC sleeper option.\nSecond Sitting (2S): Bench-style seating for short journeys.\nGeneral Class (GN):\nCheapest, unreserved seating for short-distance and affordable travel.\n4. Train Routes and Stations\nTrain Route Components:\nOrigin Station: The starting point of the train.\nDestination Station: The final stop of the train.\nIntermediate Stops: Stations where the train halts for boarding and deboarding.\nTrain Distance and Duration: Total kilometers covered and time taken.\nExample Routes:\nDelhi to Indore:\n\nTrains:\nMalwa Express (Train No. 12919/12920)\nAvantika Express (Train No. 12961/12962)\nTravel Time: ~15 hours.\nStops: Mathura, Kota, Ujjain.\nMumbai to Kolkata:\n\nTrains:\nGitanjali Express (Train No. 12859/12860)\nMumbai Mail (Train No. 12321/12322)\nTravel Time: ~30 hours.\nStops: Bhusawal, Nagpur, Rourkela.\n5. Train Timings and Schedules\nTrains operate on a 24-hour schedule.\nEach train has fixed departure and arrival times, varying slightly based on season or special occasions.\nSample Schedule\nTrain Name: Malwa Express\n\nDeparture from Delhi: 7:20 PM.\nArrival at Indore: 9:00 AM (next day).\nTotal Travel Time: ~13 hours, 40 minutes.\n6. Booking and Ticketing\nModes of Booking:\nOnline Booking:\nIRCTC website or mobile app.\nPayment options: Net banking, UPI, credit/debit cards.\nCounter Booking:\nTickets booked at railway station counters.\nKey Features in Booking:\nAdvance Reservation Period (ARP): Tickets can be booked up to 120 days before the journey.\nTatkal Scheme: Emergency ticket booking available one day before travel.\nConcessions: Senior citizens, students, and persons with disabilities receive discounts.\n7. Live Train Status and Tracking\nReal-Time Tracking Options:\nIRCTC Mobile App.\nSMS: Send SPOT <Train Number> to 139.\nOnline portals: NTES (National Train Enquiry System).\nInformation Available:\nCurrent train location.\nDelay or on-time status.\nNext scheduled stop.\n8. Frequently Asked Questions (FAQs)\nQ1: Which train goes from Delhi to Indore?\nAnswer:\n\nMalwa Express.\nAvantika Express.\nIndore Shatabdi.\nQ2: How can I check train timings for the Gitanjali Express?\nAnswer:\n\nVisit the IRCTC app or website.\nSearch for Train No. 12859/12860 under "Train Schedule."\nQ3: What is the Tatkal ticket booking time?\nAnswer:\n\nFor AC Classes: 10:00 AM, one day before the journey.\nFor Sleeper Class: 11:00 AM, one day before the journey.\nQ4: Are meals included in Rajdhani trains?\nAnswer:\n\nYes, meals are included in the ticket price. Options vary by journey duration.\n9. Additional Features in Trains\nCatering Services: Food and beverages available onboard (paid/free).\nOnboard Wi-Fi: Available in premium trains like Tejas Express.\nClean Toilets: Available in all classes.\nDisabled-Friendly Coaches: Special provisions for wheelchair access.\n10. Example of Specific Train FAQs\nDelhi to Mumbai\nTrains:\n\nRajdhani Express (Train No. 12951/12952).\nAugust Kranti Rajdhani (Train No. 12953/12954).\nTravel Time: ~16 hours.\nStops: Kota, Vadodara, Surat.\n\nChennai to Bangalore\nTrains:\n\nShatabdi Express (Train No. 12027/12028).\nBrindavan Express (Train No. 12639/12640).\nTravel Time: ~5 hours.\nStops: Katpadi, Krishnarajapuram.\n\n\n\n\n\n\nExpress Trains\nDesigned for fast, long-distance travel between major cities.\nExamples:\nRajdhani Express Series (connect state capitals to Delhi).\nShatabdi Express Series (intercity day trains).\nDuronto Express (non-stop services between major cities).\nGarib Rath Express (affordable air-conditioned travel).\nSuperfast Trains\nHigh-priority trains with speeds exceeding 55 km/h.\nExamples:\nTamil Nadu Express (Chennai to Delhi).\nHowrah Superfast Express (Howrah to Mumbai).\nMail/Express Trains\nBackbone of Indian Railways connecting cities and towns.\nExamples:\nChennai Mail.\nPunjab Mail.\nPassenger and Suburban Trains\nOperates on shorter routes with stops at every station.\nExamples:\nMumbai Local Trains.\nKolkata Circular Railway.\n2. Major Trains Categorized by Zones\nIndian Railways is divided into 18 zones. Here are some popular trains categorized by zone:\n\nNorthern Railway (NR)\nRajdhani Express (Delhi to Mumbai, Kolkata, Bangalore).\nShatabdi Express (Delhi to Lucknow, Chandigarh, Amritsar).\nKalka Mail (Howrah to Kalka).\nSouthern Railway (SR)\nTamil Nadu Express (Chennai to New Delhi).\nVaigai Express (Madurai to Chennai).\nNagercoil Express (Bangalore to Nagercoil).\nEastern Railway (ER)\nGitanjali Express (Mumbai to Kolkata).\nHowrah Express (Howrah to Ahmedabad).\nBlack Diamond Express (Howrah to Dhanbad).\nWestern Railway (WR)\nAugust Kranti Rajdhani (Mumbai to Delhi).\nMumbai Mail (Mumbai to Kolkata).\nKarnavati Express (Ahmedabad to Mumbai).\nCentral Railway (CR)\nDeccan Queen (Mumbai to Pune).\nMahalaxmi Express (Mumbai to Kolhapur).\nPunjab Mail (Mumbai to Firozpur).\n3. List of Trains by Popular Routes\nDelhi to Mumbai\nRajdhani Express (Train No. 12951/12952).\nAugust Kranti Rajdhani (Train No. 12953/12954).\nPaschim Express (Train No. 12925/12926).\nChennai to Bangalore\nShatabdi Express (Train No. 12027/12028).\nBrindavan Express (Train No. 12639/12640).\nLalbagh Express (Train No. 12607/12608).\nKolkata to Mumbai\nGitanjali Express (Train No. 12859/12860).\nMumbai Mail (Train No. 12321/12322).\nHyderabad to Delhi\nTelangana Express (Train No. 12723/12724).\nDakshin Express (Train No. 12721/12722).\nDelhi to Kolkata\nRajdhani Express (Train No. 12301/12302).\nPoorva Express (Train No. 12303/12304).\n4. How to Source Complete Train Information\nOfficial Indian Railways Database:\n\nIndian Railways provides a complete train schedule and operational details on its website.\nIRCTC API:\n\nUse IRCTC’s APIs to fetch real-time and historical data about all trains.\nFeatures include route details, train types, schedules, and more.\nNTES (National Train Enquiry System):\n\nProvides train running information, delays, and schedules.\nPublic Datasets:\n\nDownload publicly available datasets of Indian Railways (available on data.gov.in).\n5. Commonly Asked Questions\nQ1: What are the trains from Delhi to Chennai?\nAnswer:\n\nTamil Nadu Express.\nGrand Trunk Express.\nAndhra Pradesh Express.\nQ2: List the fastest trains in India.\nAnswer:\n\nVande Bharat Express (180 km/h).\nGatimaan Express (160 km/h).\nShatabdi Express (130-150 km/h).\nQ3: What facilities are available in Garib Rath Express?\nAnswer:\n\nFully air-conditioned coaches.\nAffordable ticket prices.\nLimited pantry services.\n6. Full List of Indian Trains\nSince adding thousands of trains here isn’t practical, you can:\n\nAttach Excel Sheets or Tables: List all train names, numbers, and routes.\n\nExample:\nTrain No.\tTrain Name\tOrigin Station\tDestination Station\tTravel Time\tStops\n12951\tMumbai Rajdhani\tMumbai\tDelhi\t16h\t5\n12027\tBangalore Shatabdi\tBangalore\tChennai\t5h\t2\n12303\tPoorva Express\tDelhi\tKolkata\t17h\t8\nLink External Databases: Add links to train inquiry websites.\n\n7. Training Your Chatbot\nUse datasets (e.g., train schedules, FAQs).\n\nPrepare question-answer pairs like:\n\nQ: Which train goes from Mumbai to Pune?\nA: Deccan Queen, Sinhagad Express, Pragati Express.\nQ: What is the fare for AC 3-tier on Rajdhani Express?\nA: Approx. ₹2,000 (varies by route).\nIncorporate IRCTC or NTES APIs for live data in your chatbot.\n\n\n\n\n\n\n\n1. National Emergency Numbers (Common Across India)\nPolice: 112\nFire Brigade: 101\nAmbulance: 108\nRailway Helpline: 139\nChild Helpline: 1098\nWomen’s Helpline: 181\nCyber Crime Helpline: 1930\n2. Emergency Numbers for Major Indian Cities\nDelhi\nPolice Control Room: 100\nAmbulance: 102\nFire Brigade: 101\nRailway Enquiry: 139\nEmergency Railway Station Assistance:\nEmail: delhi_station@indianrailways.gov.in\nPhone: +91-11-23366177\nMumbai\nPolice Control Room: 100\nAmbulance: 102\nFire Brigade: 101\nDisaster Management Cell: 1916\nRailway Helpline for Local Trains: 9833331111\nEmergency Railway Station Assistance:\nEmail: mumbai_central@indianrailways.gov.in\nPhone: +91-22-23094162\nKolkata\nPolice Control Room: 100\nAmbulance: 102\nFire Brigade: 101\nRailway Assistance for Howrah Station:\nEmail: howrah_station@indianrailways.gov.in\nPhone: +91-33-26411117\nKolkata Metro Helpline: 1800-345-5678\nChennai\nPolice Control Room: 100\nAmbulance: 108\nFire Brigade: 101\nRailway Assistance for Chennai Central:\nEmail: chennai_central@indianrailways.gov.in\nPhone: +91-44-25357024\nSouthern Railway Enquiry: 139\nBangalore\nPolice Control Room: 100\nAmbulance: 108\nFire Brigade: 101\nDisaster Management Cell: 080-22253707\nRailway Assistance for Bengaluru City Junction:\nEmail: bangalore_station@indianrailways.gov.in\nPhone: +91-80-22155337\nHyderabad\nPolice Control Room: 100\nAmbulance: 102\nFire Brigade: 101\nDisaster Management Cell: 040-23261165\nRailway Assistance for Secunderabad Station:\nEmail: secunderabad_station@indianrailways.gov.in\nPhone: +91-40-27700868\nPune\nPolice Control Room: 100\nAmbulance: 108\nFire Brigade: 101\nEmergency Railway Assistance:\nEmail: pune_station@indianrailways.gov.in\nPhone: +91-20-26101245\nAhmedabad\nPolice Control Room: 100\nAmbulance: 108\nFire Brigade: 101\nRailway Assistance for Ahmedabad Junction:\nEmail: ahmedabad_station@indianrailways.gov.in\nPhone: +91-79-25465522\n3. Specialized Emergency Services\nRailway-Related Emergencies\nEmergency Complaint on Train: Dial 139, select Option 5 for complaints.\nSecurity Assistance on Train (RPF Helpline): Dial 182.\nEmail for Lost Property: railwaylostproperty@indianrailways.gov.in\nCity-Specific Disaster Management Centers\nDelhi Disaster Management: 1077\nMumbai Disaster Control: 1916\nKolkata Disaster Management: +91-33-22143526\nChennai Cyclone Helpline: 1913\nHospital-Specific Helplines (City-Wise)\nAIIMS, Delhi: 011-26588500\nTata Memorial Hospital, Mumbai: +91-22-24177000\nApollo Hospitals, Chennai: +91-44-28294567\nNarayana Health, Bangalore: +91-80-71222222\n4. Railway Platform Services for Emergency Situations\nMedical Assistance on Platforms\nDelhi (New Delhi Station): Emergency medical facility available near Platform 1.\nMumbai (CST and Mumbai Central): Ambulance service within 10 minutes on request at 139.\nChennai Central: 24/7 medical aid room on Platform 5.\nLost and Found\nContact: Use helpline 139 or email the respective station’s contact address.\nExamples:\nDelhi: lost_found.delhi@indianrailways.gov.in\nMumbai: lost_found.mumbai@indianrailways.gov.in\nShelter Services\nMany cities have NGO partnerships for assisting stranded passengers:\nDelhi: Shelter homes managed by DUSIB.\nMumbai: Assistance by Railway NGOs (contact 139 for referrals).\n\n\n\n\n\nRajdhani Express (High-Priority Trains)\n12951/12952 Mumbai Rajdhani\nDeparture: Mumbai Central (17:00).\nArrival: New Delhi (08:35 next day).\n12301/12302 Howrah Rajdhani\nDeparture: Howrah (16:50).\nArrival: New Delhi (10:00 next day).\nShatabdi Express (Daytime Intercity Trains)\n12001/12002 Bhopal Shatabdi\nDeparture: New Delhi (06:00).\nArrival: Bhopal (14:00).\n12027/12028 Chennai–Bangalore Shatabdi\nDeparture: Chennai Central (06:00).\nArrival: Bangalore (11:00).\nDuronto Express (Non-Stop Long-Distance Trains)\n12245/12246 Howrah–Yesvantpur Duronto\nDeparture: Howrah (11:00).\nArrival: Yesvantpur (16:00 next day).\n12269/12270 Chennai–Hazrat Nizamuddin Duronto\nDeparture: Chennai Central (06:40).\nArrival: Hazrat Nizamuddin (10:30 next day).\n3. Categorized Timetable Information\nBy Region (North, South, East, West, Central)\nNorthern India\nPunjab Mail (12137/12138)\nMumbai CST: 19:40 → Firozpur Cantt: 04:45 (next day).\nJammu Tawi Express (12425/12426)\nNew Delhi: 21:50 → Jammu Tawi: 05:45 (next day).\nSouthern India\nTamil Nadu Express (12621/12622)\nChennai Central: 22:00 → New Delhi: 07:00 (2nd day).\nKSR Bengaluru Rajdhani (22691/22692)\nBangalore: 20:00 → New Delhi: 05:55 (next day).\nEastern India\nGitanjali Express (12859/12860)\nHowrah: 13:50 → Mumbai CST: 21:20 (next day).\nPuri Express (12801/12802)\nPuri: 20:45 → New Delhi: 05:55 (next day).\nWestern India\nAugust Kranti Rajdhani (12953/12954)\nMumbai Central: 17:40 → Hazrat Nizamuddin: 10:55 (next day).\nGolden Temple Mail (12903/12904)\nMumbai CST: 21:30 → Amritsar: 05:55 (next day).\nCentral India\nNarmada Express (18233/18234)\nIndore: 17:45 → Bilaspur: 14:45 (next day).\nKamayani Express (11071/11072)\nLokmanya Tilak Terminus: 15:55 → Varanasi: 21:45 (next day).\n'),
  );
  }

  // Add this method to get category-specific prompts
  String _getCategorySpecificPrompt(String category) {
    switch (category) {
      case 'Women Safety':
        return 'Please provide details about the safety concern:\n'
            '• Location/Coach number\n'
            '• Nature of the incident\n'
            '• Time of incident\n'
            '• Description of the person(s) involved (if applicable)\n'
            '• Any immediate action taken';
      case 'Washroom Cleanliness':
        return 'Please provide details about the cleanliness issue:\n'
            '• Coach number\n'
            '• Specific cleanliness problems\n'
            '• How long has this been an issue\n'
            '• Any other relevant details';
      case 'Food Quality':
        return 'Please provide details about the food quality issue:\n'
            '• Type of food item\n'
            '• Vendor/Service provider name\n'
            '• Nature of the problem\n'
            '• Time of purchase\n'
            '• Receipt number (if available)';
      case 'Staff Behavior':
        return 'Please provide details about the staff behavior:\n'
            '• Staff member\'s designation (if known)\n'
            '• Nature of the incident\n'
            '• Location and time\n'
            '   Any witnesses present';
      case 'Train Cleanliness':
        return 'Please provide details about the cleanliness issue:\n'
            '• Coach number\n'
            '• Specific area of concern\n'
            '• Duration of the problem\n'
            '• Any health hazards observed';
      case 'AC/Fan Not Working':
        return 'Please provide details about the AC/Fan issue:\n'
            '• Coach number and seat number\n'
            '• Nature of the problem\n'
            '• How long has it been not working\n'
            '• Current temperature condition';
      case 'Unauthorized Vendors':
        return 'Please provide details about unauthorized vendors:\n'
            '• Location in train\n'
            '• Type of goods being sold\n'
            '• Time of incident\n'
            '• Any harassment faced';
      case 'Delayed Trains':
        return 'Please provide details about the delay:\n'
            '• Train number\n'
            '• Scheduled time\n'
            '• Current delay duration\n'
            '• Current location';
      case 'Bedroll Quality':
        return 'Please provide details about bedroll quality:\n'
            '• Coach and berth number\n'
            '• Specific issues with bedroll\n'
            ' Cleanliness concerns\n'
            '• Any allergic reactions';
      case 'Security Concerns':
        return 'Please provide details about security concerns:\n'
            '• Nature of security threat\n'
            '• Location in train\n'
            '• Time of observation\n'
            '• Any immediate danger';
      case 'Water Availability':
        return 'Please provide details about water availability:\n'
            '• Coach number\n'
            '• Nature of the problem\n'
            '• Duration of unavailability\n'
            '• Current situation';
      case 'Overcrowding Issues':
        return 'Please provide details about overcrowding:\n'
            '• Coach number\n'
            '• Nature of overcrowding\n'
            '• Number of extra passengers (approximate)\n'
            '• Any specific incidents';
      case 'Medical Emergency':
        return 'Please provide details about medical emergency:\n'
            '• Nature of medical problem\n'
            '• Patient\'s condition\n'
            '• Coach and seat number\n'
            '• Any first aid administered';
      case 'Lost Belongings':
        return 'Please provide details about lost belongings:\n'
            '• Description of lost item(s)\n'
            '• Last seen location\n'
            '• Time when noticed missing\n'
            '• Any identifying marks';
      case 'Platform Facilities':
        return 'Please provide details about platform facilities:\n'
            '• Station name\n'
            '• Platform number\n'
            '• Specific facility issue\n'
            '• Duration of the problem';
      default:
        return 'Please provide detailed information about your complaint:';
    }
  }

  // Update the _handleComplaintSelection method
  void _handleComplaintSelection(String category) {
    setState(() {
      selectedComplaintCategory = category;
      _messages.add(
          {'type': 'bot', 'message': _getCategorySpecificPrompt(category)});
      isRegisteringComplaint = true;
    });
  }

  // Add this function to your _ChatbotScreenState class
  Future<void> _submitComplaint(String type, String description) async {
    try {
      final response = await http.post(
        Uri.parse('https://sih-pravaah.onrender.com/api/complaints/create'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'referenceNo': DateTime.now().millisecondsSinceEpoch,
          'type': type,
          'description': description,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        setState(() {
          _messages.add({
            'type': 'bot',
            'message': 'Complaint registered successfully!\n'
                'Reference ID: ${responseData['data']['_id']}\n'
                'Type: ${responseData['data']['type']}\n'
                'Status: ${responseData['data']['resolved'] ? 'Resolved' : 'Pending'}'
          });
        });
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to submit complaint');
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'type': 'bot',
          'message': 'Error submitting complaint: $e',
        });
      });
    }
  }

  // Modify the _sendMessage method to handle complaints
  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      _messages.add({'type': 'user', 'message': message});
      _isLoading = true;
    });

    try {
      if (isRegisteringComplaint) {
        // Extract complaint number from user input
        if (message.length == 1 && int.tryParse(message) != null) {
          int complaintNumber = int.parse(message);
          if (complaintNumber >= 1 &&
              complaintNumber <= complaintCategories.length) {
            String selectedCategory = complaintCategories[complaintNumber - 1];
            _handleComplaintSelection(selectedCategory);
          } else {
            setState(() {
              _messages.add({
                'type': 'bot',
                'message':
                    'Please select a valid complaint number between 1 and ${complaintCategories.length}.'
              });
            });
          }
        } else if (selectedComplaintCategory != null) {
          // This is the detailed complaint message
          await _submitComplaint(selectedComplaintCategory!, message);
          setState(() {
            isRegisteringComplaint = false;
            selectedComplaintCategory = null;
          });
        }
      } else {
        // Normal chatbot conversation
        final chat = _model.startChat(history: [
          Content.multi([TextPart(message)]),
        ]);

        final content = Content.text(message);
        final response = await chat.sendMessage(content);

        setState(() {
          _messages.add({'type': 'bot', 'message': response.text!});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({'type': 'bot', 'message': 'Error: ${e.toString()}'});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _startListening() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(
          onResult: (result) {
            setState(() {
              _controller.text = result.recognizedWords;
              if (result.finalResult) {
                _isListening = false;
                // Automatically send message when voice input is complete
                if (_controller.text.isNotEmpty) {
                  _sendMessage(_controller.text);
                  _controller.clear();
                }
              }
            });
          },
          localeId: 'en_US', // You can change this based on user's language
        );
      }
    }
  }

  void _stopListening() {
    if (_isListening) {
      _speechToText.stop();
      setState(() => _isListening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: const Color(0xFF4B5EFC),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.support_agent,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Railway Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'CourierPrime',
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: !isRegisteringComplaint
                ? Container(
                    key: const ValueKey<String>('complaint_button'),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          isRegisteringComplaint = true;
                          _messages.add({
                            'type': 'bot',
                            'message': 'Please select your complaint category by entering the number:\n\n${complaintCategories.asMap().entries.map((entry) {
                                  return '${entry.key + 1}. ${entry.value}';
                                }).join('\n')}',
                          });
                        });
                      },
                      icon: const Icon(Icons.report_problem),
                      label: const Text('Register Complaint'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B5EFC),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          if (_isLoading) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF4B5EFC)),
                ),
              ),
            ),
          ],
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUserMessage = message['type'] == 'user';
                final messageText = message['message']!;

                return Align(
                  alignment: isUserMessage 
                      ? Alignment.centerRight 
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isUserMessage
                          ? const Color(0xFF4B5EFC)
                          : const Color(0xFFF1F3FF),
                        borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Text(
                      messageText,
                      style: TextStyle(
                        color: isUserMessage ? Colors.white : const Color(0xFF4B5EFC),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: _isListening ? 'Listening...' : 'Type a message...',
                      hintStyle: TextStyle(color: const Color(0xFF4B5EFC).withOpacity(0.6)),
                      filled: true,
                      fillColor: const Color(0xFFF1F3FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    style: const TextStyle(color: Color(0xFF4B5EFC)),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF4B5EFC),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                    color: Colors.white,
                    onPressed: _isListening ? _stopListening : _startListening,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF4B5EFC),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send),
                    color: Colors.white,
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        _sendMessage(_controller.text);
                        _controller.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _speechToText.stop();
    _notificationTimer?.cancel();
    super.dispose();
  }
}

class StationDetailsPage extends StatelessWidget {
  final String stationName;

  const StationDetailsPage({
    super.key,
    required this.stationName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          stationName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4B5EFC),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100), // Space for AppBar

            // Navigation options in a more appealing layout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildNavigationTile(
                    icon: Icons.navigation_rounded,
                    title: LocalizationService.translate('start_navigation'),
                    color: const Color(0xFF4B5EFC),
                    onTap: () {
                      // Navigation logic
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildNavigationTile(
                    icon: Icons.accessibility_new,
                    title: LocalizationService.translate('static_navigation'),
                    color: const Color(0xFF2196F3),
                    onTap: () {
                      // Blind-friendly navigation logic
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildNavigationTile(
                    icon: Icons.view_in_ar,
                    title: LocalizationService.translate('view_3d_model'),
                    color: const Color(0xFF4CAF50),
                    onTap: () async {
                      if (!await launchUrl(
                          Uri.parse('https://sih-3d.vercel.app/'))) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Could not launch 3D model viewer'),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildNavigationTile(
                    icon: Icons.camera,
                    title: LocalizationService.translate('ar_view'),
                    color: const Color(0xFFFF5722),
                    onTap: () async {
                      final url = Uri.parse('https://chamaat.vercel.app/');
                      if (!await launchUrl(url,
                          mode: LaunchMode.externalApplication)) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Could not launch AR view'),
                              backgroundColor: Color(0xFFFF5722),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            color.withOpacity(0.8),
            color,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: flutter_material.Material(
        // Use the specific Material widget
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.white.withOpacity(0.2),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    icon,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.7),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
