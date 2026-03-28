import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/models/cart.dart';
import 'package:restaurant_app/pages/providers/cart_provider.dart';
import 'package:restaurant_app/pages/cart/checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: _buildCartList(context),
                ),

                // 🔴 LIFTED BUTTON (not stuck to bottom)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  child: _checkoutButton(context),
                ),
              ],
            ),
    );
  }

  // CART LIST
  Widget _buildCartList(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.items;

    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        return _cartItem(context, cart, cartItems[index], index);
      },
    );
  }

  // CART ITEM
  Widget _cartItem(
      BuildContext context, CartProvider cart, CartItem item, int index) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(item.image, width: 70, height: 70),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(item.price,
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),

                Row(
                  children: [
                    _qtyButton("-", () {
                      cart.decrementQuantity(index);
                    }),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(item.quantity.toString()),
                    ),

                    _qtyButton("+", () {
                      cart.incrementQuantity(index);
                    }),
                  ],
                )
              ],
            ),
          ),

          // DELETE
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              cart.removeFromCart(index);
            },
          ),
        ],
      ),
    );
  }

  // QTY BUTTON
  Widget _qtyButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(text),
      ),
    );
  }

  // CHECKOUT BUTTON
  Widget _checkoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CheckoutPage(),
            ),
          );
        },
        child: const Text(
          "Proceed to Checkout",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}