import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          _DrawerItem(title: "Home", route: "/"),
          _DrawerItem(title: "About", route: "/about"),
          _DrawerItem(title: "Buy", route: "/buy"),
          _DrawerItem(title: "Sell", route: "/sell"),
          _DrawerItem(title: "Login", route: "/login"),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String title;
  final String route;
  const _DrawerItem({required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
    );
  }
}
