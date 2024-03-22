import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
    required this.isConnected,
  });
  final String title;
  final bool isConnected;
  final IconData icon;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Row(
        children: [
          Icon(icon, color: isConnected ? Colors.green : Colors.white),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                title,
                style:
                    TextStyle(color: isConnected ? Colors.green : Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
