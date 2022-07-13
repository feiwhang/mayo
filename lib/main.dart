import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mayo/firebase/auth_services.dart';
import 'package:mayo/providers/lang_code_provider.dart';
import 'package:mayo/screens/shared/landing_screen.dart';
import 'package:mayo/screens/shared/main_screen.dart';
import 'package:mayo/utils/constants/main_const.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: Mayo()));
}

class Mayo extends ConsumerWidget {
  const Mayo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? langCode = ref.watch(langCodeProvider);

    final LangCodeNotifier langCodeNotifier =
        ref.read(langCodeProvider.notifier);

    return FutureBuilder<String>(
      future: langCodeNotifier.setLangCodeFromSharedPref(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Mayo',
            theme: ThemeData(
              textTheme:
                  GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('th', ''),
            ],
            locale: Locale(langCode ?? 'en', ''),
            home:
                isAuthenticated() ? const MainScreen() : const LandingScreen(),
            navigatorKey: navigatorKey,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
