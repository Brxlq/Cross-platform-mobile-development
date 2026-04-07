import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/components.dart';
import '../models/models.dart';
import '../screens/screens.dart';
import 'constants.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.auth,
    required this.cartManager,
    required this.ordersManager,
    required this.changeTheme,
    required this.changeColor,
    required this.colorSelected,
    required this.tab,
  });

  final YummyAuth auth;
  final int tab;
  final CartManager cartManager;
  final OrderManager ordersManager;
  final ColorSelection colorSelected;
  final void Function(bool useLightMode) changeTheme;
  final void Function(int value) changeColor;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<NavigationDestination> appBarDestinations = const [
    NavigationDestination(
      icon: Icon(Icons.explore_outlined),
      label: 'Discover',
      selectedIcon: Icon(Icons.explore),
    ),
    NavigationDestination(
      icon: Icon(Icons.route_outlined),
      label: 'Trips',
      selectedIcon: Icon(Icons.route),
    ),
    NavigationDestination(
      icon: Icon(Icons.person_2_outlined),
      label: 'Profile',
      selectedIcon: Icon(Icons.person),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      ExplorePage(
        cartManager: widget.cartManager,
        orderManager: widget.ordersManager,
      ),
      MyOrdersPage(orderManager: widget.ordersManager),
      AccountPage(
        onLogOut: (logout) async {
          await widget.auth.signOut();
          if (!context.mounted) return;
          context.go('/login');
        },
        user: User(
          firstName: 'Yerkebulan',
          lastName: 'Sovet',
          role: 'Echelon Member',
          profileImageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Red_Hood_Logo.svg/512px-Red_Hood_Logo.svg.png',
          points: 2400,
          darkMode: true,
        ),
      ),
    ];

    final subtitle = switch (widget.tab) {
      0 => 'Shared vehicles for every kind of city day',
      1 => 'Your upcoming reservations',
      _ => 'Membership, preferences, and support',
    };

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ECHELON',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        actions: [
          ThemeButton(changeThemeMode: widget.changeTheme),
          ColorButton(
            changeColor: widget.changeColor,
            colorSelected: widget.colorSelected,
          ),
        ],
      ),
      body: IndexedStack(index: widget.tab, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.tab,
        onDestinationSelected: (index) => context.go('/$index'),
        destinations: appBarDestinations,
      ),
    );
  }
}
