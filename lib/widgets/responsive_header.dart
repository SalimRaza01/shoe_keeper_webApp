import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResponsiveHeader extends StatelessWidget implements PreferredSizeWidget {
  const ResponsiveHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return AppBar(
      title: const Text("MyLogo"),
      backgroundColor: Colors.blue.shade700,
      actions: isMobile
          ? [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
              ),
            ]
          : [
              _NavButton(title: "Home", route: "/"),
              _NavButton(title: "About", route: "/about"),
              _NavButton(title: "Shop", route: "/shop"),
              _NavButton(title: "Buy", route: "/buy"),
              _NavButton(title: "Sell", route: "/sell"),
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.login),
                onPressed: () => context.go('/login'),
              ),
            ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _NavButton extends StatelessWidget {
  final String title;
  final String route;
  const _NavButton({required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.go(route),
      child: Text(title, style: const TextStyle(color: Colors.white)),
    );
  }
}
