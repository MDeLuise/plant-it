import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/locale_provider.dart';
import 'package:provider/provider.dart';

class ChangeLanguagePage extends StatefulWidget {
  final Environment env;

  const ChangeLanguagePage({
    super.key,
    required this.env,
  });

  @override
  State<StatefulWidget> createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  Locale? _selectedLocale;
  final Map<String, String> languageNames = {
    'af': 'Afrikaans',
    'am': 'Amharic',
    'ar': 'Arabic',
    'as': 'Assamese',
    'az': 'Azerbaijani',
    'be': 'Belarusian',
    'bg': 'Bulgarian',
    'bn': 'Bengali Bangla',
    'bs': 'Bosnian',
    'ca': 'Catalan Valencian',
    'cs': 'Czech',
    'cy': 'Welsh',
    'da': 'Danish',
    'de': 'German',
    'el': 'Modern Greek',
    'en': 'English',
    'es': 'Spanish Castilian',
    'et': 'Estonian',
    'eu': 'Basque',
    'fa': 'Persian',
    'fi': 'Finnish',
    'fil': 'Filipino Pilipino',
    'fr': 'French',
    'gl': 'Galician',
    'gsw': 'Swiss German Alemannic Alsatian',
    'gu': 'Gujarati',
    'he': 'Hebrew',
    'hi': 'Hindi',
    'hr': 'Croatian',
    'hu': 'Hungarian',
    'hy': 'Armenian',
    'id': 'Indonesian',
    'is': 'Icelandic',
    'it': 'Italian',
    'ja': 'Japanese',
    'ka': 'Georgian',
    'kk': 'Kazakh',
    'km': 'Khmer Central Khmer',
    'kn': 'Kannada',
    'ko': 'Korean',
    'ky': 'Kirghiz Kyrgyz',
    'lo': 'Lao',
    'lt': 'Lithuanian',
    'lv': 'Latvian',
    'mk': 'Macedonian',
    'ml': 'Malayalam',
    'mn': 'Mongolian',
    'mr': 'Marathi',
    'ms': 'Malay',
    'my': 'Burmese',
    'nb': 'Norwegian Bokmål',
    'ne': 'Nepali',
    'nl': 'Dutch Flemish',
    'no': 'Norwegian',
    'or': 'Oriya',
    'pa': 'Panjabi Punjabi',
    'pl': 'Polish',
    'ps': 'Pushto Pashto',
    'pt': 'Portuguese',
    'ro': 'Romanian Moldavian Moldovan',
    'ru': 'Russian',
    'si': 'Sinhala Sinhalese',
    'sk': 'Slovak',
    'sl': 'Slovenian',
    'sq': 'Albanian',
    'sr': 'Serbian',
    'sv': 'Swedish',
    'sw': 'Swahili',
    'ta': 'Tamil',
    'te': 'Telugu',
    'th': 'Thai',
    'tl': 'Tagalog',
    'tr': 'Turkish',
    'uk': 'Ukrainian',
    'ur': 'Urdu',
    'uz': 'Uzbek',
    'vi': 'Vietnamese',
    'zh': 'Chinese',
    'zu': 'Zulu',
  };

  @override
  void initState() {
    super.initState();
    _selectedLocale =
        Provider.of<LocaleProvider>(context, listen: false).locale;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).changeLanguage),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: AppLocalizations.supportedLocales.map((locale) {
                return ListTile(
                  title: Text(
                    languageNames[locale.toLanguageTag()] ?? "",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  leading: Radio<Locale>(
                    value: locale,
                    groupValue: _selectedLocale ?? Localizations.localeOf(context),
                    onChanged: (Locale? value) {
                      setState(() {
                        _selectedLocale = value;
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      _selectedLocale = locale;
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedLocale != null) {
            Provider.of<LocaleProvider>(context, listen: false)
                .setLocale(_selectedLocale!);
          }
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
