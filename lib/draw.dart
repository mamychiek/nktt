import 'package:blogger_api/models/postitem.model.dart';
import 'package:flutter/material.dart';
import './view/faforableitem.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
    required this.onSelectScreen,
    required this.ontoggleMeal,
  });

  final void Function(String identifier) onSelectScreen;
  final void Function(PostItemModel element) ontoggleMeal;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColorDark,
                  Theme.of(context).colorScheme.primaryContainer,
                ],
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.fastfood,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 18),
                Text(
                  ' بصحة و العافية',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => const AboutPage()));
            },
            leading: Icon(
              Icons.message,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'تواصل ممعنا ',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => const OtherAppPage()));
            },
            leading: Icon(
              Icons.apps,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              ' تطبيقات',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
