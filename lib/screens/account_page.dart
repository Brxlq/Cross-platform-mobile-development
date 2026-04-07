import 'package:flutter/material.dart';

import '../models/models.dart';

typedef LogoutCallback = void Function(bool didLogout);

class AccountPage extends StatefulWidget {
  const AccountPage({
    super.key,
    required this.onLogOut,
    required this.user,
  });

  final User user;
  final LogoutCallback onLogOut;

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  ImageProvider<Object> _profileImage(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return NetworkImage(imagePath);
    }
    return AssetImage(imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildProfile(),
          const SizedBox(height: 20),
          buildMembershipCard(),
          const SizedBox(height: 20),
          buildMenu(),
        ],
      ),
    );
  }

  Widget buildMembershipCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF0B1220), Color(0xFF1A4F8C)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Echelon Plus',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Priority access to performance vehicles, lower hourly '
            'rates, and free extra-driver coverage.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.82)),
          ),
        ],
      ),
    );
  }

  Widget buildMenu() {
    return Column(
      children: [
        const ListTile(
          leading: Icon(Icons.credit_card_outlined),
          title: Text('Billing and passes'),
          subtitle: Text('Manage payment methods and trip credits'),
        ),
        const ListTile(
          leading: Icon(Icons.support_agent),
          title: Text('Support'),
          subtitle: Text('Roadside help, damage reporting, and FAQs'),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Log out'),
          onTap: () {
            widget.onLogOut(true);
          },
        ),
      ],
    );
  }

  Widget buildProfile() {
    return Column(
      children: [
        CircleAvatar(
          radius: 56,
          backgroundImage: _profileImage(widget.user.profileImageUrl),
        ),
        const SizedBox(height: 16),
        Text(
          '${widget.user.firstName} ${widget.user.lastName}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        Text(widget.user.role),
        Text('${widget.user.points} member points'),
      ],
    );
  }
}
