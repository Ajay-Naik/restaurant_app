import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/pages/providers/cart_provider.dart';
import 'package:restaurant_app/pages/main/home_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedPayment = "COD";

  final upiController = TextEditingController();
  final cardNumberController = TextEditingController();
  final cardNameController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Payment Method",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 12),

                    RadioGroup<String>(
                      groupValue: selectedPayment,
                      onChanged: (value) {
                        setState(() {
                          selectedPayment = value!;
                        });
                      },
                      child: Column(
                        children: const [
                          RadioListTile(
                            value: "COD",
                            title: Text("Cash on Delivery"),
                          ),
                          RadioListTile(
                            value: "UPI",
                            title: Text("UPI Payment"),
                          ),
                          RadioListTile(
                            value: "CARD",
                            title: Text("Credit/Debit Card"),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (selectedPayment == "UPI") _upiInput(),
                    if (selectedPayment == "CARD") _cardInputs(),
                  ],
                ),
              ),
            ),

            // 🔴 PLACE ORDER BUTTON
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _placeOrder,
                  child: const Text(
                    "Place Order",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔴 LOGIC
void _placeOrder() async {
  final cart = Provider.of<CartProvider>(context, listen: false);

  // validation
  if (selectedPayment == "UPI" && upiController.text.isEmpty) {
    _showError("Enter UPI ID");
    return;
  }

  if (selectedPayment == "CARD" &&
      (cardNumberController.text.isEmpty ||
          cardNameController.text.isEmpty ||
          expiryController.text.isEmpty ||
          cvvController.text.isEmpty)) {
    _showError("Fill all card details");
    return;
  }

  // 🔴 show confirmation
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Order placed successfully"),
      duration: Duration(seconds: 2),
    ),
  );

  // 🔴 wait (so user perceives it)
  await Future.delayed(const Duration(seconds: 2));

  // 🔴 clear cart
  cart.clearCart();

  // 🔴 navigate
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => const HomePage()),
    (route) => false,
  );
}
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Widget _upiInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Enter UPI ID"),
        const SizedBox(height: 8),
        TextField(
          controller: upiController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "example@upi",
          ),
        ),
      ],
    );
  }

  Widget _cardInputs() {
    return Column(
      children: [
        TextField(
          controller: cardNumberController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Card Number",
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: cardNameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Card Holder Name",
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: expiryController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "MM/YY",
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: cvvController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "CVV",
                ),
                obscureText: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}