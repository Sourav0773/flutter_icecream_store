import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icecream_store/pages/order_confirmation/order_confirmation_page.dart';
import 'dart:convert';
import '/models/icecream_data_model.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  UserState createState() => UserState();
}

class UserState extends State<User> {
  List<IceCream> iceCreamData = [];
  List<IceCream> cart = [];

  double usdToInrConversionRate = 80.0;

  Future<void> fetchIceCreamData() async {
    final response = await http.get(Uri.parse(
        'https://6796a736bedc5d43a6c5cdd8.mockapi.io/api/icecreams/icecreamdata'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        iceCreamData = data.map((item) => IceCream.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load ice cream data');
    }
  }

  void addToCart(IceCream iceCream) {
    setState(() {
      cart.add(iceCream);
    });
  }

  void removeFromCart(IceCream iceCream) {
    setState(() {
      cart.remove(iceCream);
    });
  }

  double calculateTotal() {
    double total = 0;
    for (var item in cart) {
      total += item.price!;
    }
    return total;
  }

  Future<void> sendOrderToAdmin() async {
    if (kDebugMode) {
      print("Order sent to Admin: ${cart.map((item) => item.name).join(", ")}");
    }
    setState(() {
      cart.clear();
    });

    // Navigate to the Order Confirmation Page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OrderConfirmationPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchIceCreamData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text('Ice Cream Shop',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Displaying ice cream list in a GridView
              iceCreamData.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: iceCreamData.length,
                      itemBuilder: (context, index) {
                        IceCream iceCream = iceCreamData[index];
                        double priceInInr =
                            iceCream.price! * usdToInrConversionRate;

                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Image section
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                    child: Image.network(
                                      iceCream.image!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                // Name and price
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        iceCream.name!,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '₹${priceInInr.toStringAsFixed(2)}',
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.green),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                // Add to Cart Button
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () => addToCart(iceCream),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Icon(Icons.add_shopping_cart,
                                        size: 24, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              // Displaying cart if items exist
              if (cart.isNotEmpty)
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text("Your Cart",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: cart.length,
                        itemBuilder: (context, index) {
                          IceCream item = cart[index];
                          double priceInInr =
                              item.price! * usdToInrConversionRate;

                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(8.0),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(item.image!,
                                    width: 50, height: 50, fit: BoxFit.cover),
                              ),
                              title: Text(item.name!),
                              subtitle: Text(
                                  'Price: ₹${priceInInr.toStringAsFixed(2)}'),
                              trailing: IconButton(
                                icon: Icon(Icons.remove_circle,
                                    color: Colors.red),
                                onPressed: () => removeFromCart(item),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Total: ₹${calculateTotal() * usdToInrConversionRate}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: sendOrderToAdmin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Send Order to Admin',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
