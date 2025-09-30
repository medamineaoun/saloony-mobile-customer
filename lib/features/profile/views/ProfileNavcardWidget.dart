import 'package:flutter/material.dart';

class ProfileNavcardWidget extends StatelessWidget {
  final String navName;
  final Icon navIcon;
  final VoidCallback? onTap;

  const ProfileNavcardWidget({
    super.key,
    required this.navName,
    required this.navIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: navIcon,
        title: Text(navName),
        onTap: onTap,
      ),
    );
  }
}
