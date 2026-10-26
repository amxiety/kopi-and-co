import 'package:flutter/material.dart';

void main() {
  runApp(const KopiAndCoApp());
}

const coffeeBrown = Color(0xFF604632);
const cream = Color(0xFFFAF5EC);
const sage = Color(0xFFDCE5D5);
const darkText = Color(0xFF302820);

class KopiAndCoApp extends StatelessWidget {
  const KopiAndCoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kopi & Co.',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: coffeeBrown),
        appBarTheme: const AppBarTheme(
          backgroundColor: cream,
          foregroundColor: darkText,
        ),
      ),
      home: const MenuPage(),
    );
  }
}

class MenuItem {
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;

  const MenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });
}

const menuItems = [
  MenuItem(
    name: 'Kopi Latte',
    description: 'Espresso with smooth steamed milk',
    price: 10.00,
    category: 'Coffee',
    imageUrl:
        'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=600',
  ),
  MenuItem(
    name: 'Iced Americano',
    description: 'Bold espresso served over ice',
    price: 8.00,
    category: 'Coffee',
    imageUrl:
        'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=600',
  ),
  MenuItem(
    name: 'Matcha Latte',
    description: 'Creamy Japanese green tea',
    price: 12.00,
    category: 'Tea',
    imageUrl: 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?w=600',
  ),
  MenuItem(
    name: 'Butter Croissant',
    description: 'Golden, flaky and freshly baked',
    price: 7.00,
    category: 'Bakery',
    imageUrl: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=600',
  ),
];

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String selectedCategory = 'All';
  int cartCount = 0;

  final categories = ['All', 'Coffee', 'Tea', 'Bakery'];

  @override
  Widget build(BuildContext context) {
    final filteredItems = menuItems.where((item) {
      return selectedCategory == 'All' || item.category == selectedCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.coffee, color: coffeeBrown, size: 28),
            SizedBox(width: 10),
            Text('Kopi & Co.', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Badge(
              label: Text('$cartCount'),
              isLabelVisible: cartCount > 0,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: coffeeBrown,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.wb_sunny_outlined,
                    color: Color(0xFFE8D5B7),
                    size: 30,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'A good day starts\nwith good coffee.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your daily cup, made with love.',
                    style: TextStyle(color: Color(0xFFF0E5D8), fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Find your favourite',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final selected = selectedCategory == category;

                  return ChoiceChip(
                    label: Text(category),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    selectedColor: coffeeBrown,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : coffeeBrown,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's picks",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                Text(
                  '${filteredItems.length} items',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...filteredItems.map(
              (item) => MenuItemCard(
                item: item,
                onAdd: () {
                  setState(() {
                    cartCount++;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.name} added to your bag!'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Kopi & Co. • Brewed for your everyday',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onAdd;

  const MenuItemCard({super.key, required this.item, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                item.imageUrl,
                width: 105,
                height: 115,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 105,
                    height: 115,
                    color: sage,
                    child: const Icon(
                      Icons.coffee,
                      size: 38,
                      color: coffeeBrown,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.category.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF8B765E),
                      fontSize: 10,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'RM ${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: coffeeBrown,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton.filled(
                        onPressed: onAdd,
                        icon: const Icon(Icons.add),
                        tooltip: 'Add to bag',
                        style: IconButton.styleFrom(
                          backgroundColor: coffeeBrown,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
