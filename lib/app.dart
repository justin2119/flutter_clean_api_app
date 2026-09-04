import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/localization/app_localizations.dart';
import 'presentation/providers/locale_provider.dart';
import 'presentation/screens/bookmarks_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/search_screen.dart';
import 'presentation/screens/settings_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp(
        title: 'Flutter Clean API App',
        locale: ref.watch(localeProvider),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [AppLocalizationsDelegate()],
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFF263238),
          colorScheme: const ColorScheme.dark(
            surface: Color(0xFF37474F),
            primary: Color(0xFF4CAF50),
            onPrimary: Color(0xFFFFFFFF),
            onSurface: Color(0xFFFFFFFF),
          ),
          textTheme: GoogleFonts.abelTextTheme(ThemeData.dark().textTheme),
          appBarTheme: const AppBarTheme(
            elevation: 0.0,
            backgroundColor: Color(0xFF37474F),
          ),
          cardTheme: const CardTheme(
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            color: Color(0xFF37474F),
          ),
        ),
        home: const MainNavigation(),
      );
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(
          index: index,
          children: const [
            HomeScreen(),
            _DetailLanding(),
            BookmarksScreen(),
            SearchScreen(),
            SettingsScreen(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (value) => setState(() => index = value),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Feed'),
            NavigationDestination(icon: Icon(Icons.article), label: 'Detail'),
            NavigationDestination(
              icon: Icon(Icons.bookmark),
              label: 'Bookmarks',
            ),
            NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      );
}

class _DetailLanding extends StatelessWidget {
  const _DetailLanding();

  @override
  Widget build(BuildContext context) => const Scaffold(
        appBar: AppBar(title: Text('Article detail')),
        body: Center(child: Text('Select an article from the news feed.')),
      );
}
