import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/models/cart.dart';
import 'package:restaurant_app/themes/dark_mode.dart';
import 'package:restaurant_app/themes/light_mode.dart';
import 'package:restaurant_app/pages/cart/cart_page.dart';
import 'package:restaurant_app/pages/providers/cart_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String deliveryAddress = "99 Hollywood Blvd";
  String selectedCategory = "burgers";

  final menuData = {
    "burgers": [
      {
        "name": "Classic Cheeseburger",
        "price": "\$8.99",
        "desc": "A juicy beef patty...",
        "image": "images/Classic_Cheeseburger.png",
      },
      {
        "name": "BBQ Bacon Burger",
        "price": "\$10.99",
        "desc": "Smoky BBQ sauce...",
        "image": "images/BBQ_Bacon_Burger.png",
      },
    ],
    "salads": [
      {
        "name": "Caesar Salad",
        "price": "\$6.99",
        "desc": "Fresh romaine lettuce...",
        "image": "images/caesar_salad.png",
      },
    ],
    "sides": [
      {
        "name": "French Fries",
        "price": "\$3.99",
        "desc": "Crispy golden fries",
        "image": "images/fries.png",
      },
    ],
    "dessert": [
      {
        "name": "Chocolate Cake",
        "price": "\$5.99",
        "desc": "Rich chocolate delight",
        "image": "images/cake.png",
      },
    ],
    "drinks": [
      {
        "name": "Coke",
        "price": "\$1.99",
        "desc": "Chilled soft drink",
        "image": "images/coke.png",
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sunset Diner"),
        leading: const Icon(Icons.menu),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          _buildHeader(),
          _buildCategories(),
          Expanded(child: _buildMenuList()),
        ],
      ),
    );
  }

  // HEADER
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Delivery now", style: TextStyle(color: Colors.grey)),

          GestureDetector(
            onTap: _showAddressDialog,
            child: Row(
              children: [
                Text(
                  deliveryAddress,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoBox("\$0.99", "Delivery Fee"),
              _infoBox("15-30 min", "Delivery time"),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddressDialog() {
    final controller = TextEditingController(text: deliveryAddress);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter new address"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Enter delivery address",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) return;

                setState(() {
                  deliveryAddress = controller.text;
                });

                Navigator.pop(context);
              },
              child: const Text("Save", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  Widget _infoBox(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // CATEGORIES
  Widget _buildCategories() {
    final categories = menuData.keys.toList();

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                category,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: selectedCategory == category
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // MENU LIST
  Widget _buildMenuList() {
    final items = menuData[selectedCategory]!;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return _menuItem(
          item["name"]!,
          item["price"]!,
          item["desc"]!,
          item["image"]!,
        );
      },
    );
  }

  Widget _menuItem(String title, String price, String desc, String image) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(price, style: const TextStyle(color: Colors.grey)),
                Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // IMAGE + BUTTON
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  image,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                bottom: 6,
                right: 6,
                child: GestureDetector(
                  onTap: () {
                    final cart = Provider.of<CartProvider>(
                      context,
                      listen: false,
                    );

                    cart.addToCart(
                      CartItem(name: title, price: price, image: image),
                    );

                    // feedback
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("$title added to cart"),
                        duration: const Duration(milliseconds: 800),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
