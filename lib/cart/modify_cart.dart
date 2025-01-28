import 'package:flutter/material.dart';

class ModifyCart extends StatefulWidget {
  const ModifyCart({super.key});

  @override
  ModifyCartState createState() => ModifyCartState();
}

class ModifyCartState extends State<ModifyCart> {
  // Dummy data
  List<Map<String, dynamic>> cartItems = [
    {'name': 'Item 1', 'price': 10.0, 'quantity': 1},
    {'name': 'Item 2', 'price': 15.0, 'quantity': 2},
    {'name': 'Item 3', 'price': 7.5, 'quantity': 3},
  ];

  // Function to update quantity
  void updateQuantity(int index, int newQuantity) {
    setState(() {
      cartItems[index]['quantity'] = newQuantity;
    });
  }

  // Function to remove item from cart
  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modify Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          var item = cartItems[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Item name and price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['name'],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('\$${item['price']}'),
                    ],
                  ),
                  const Spacer(),
                  // Quantity adjuster
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (item['quantity'] > 1) {
                            updateQuantity(index, item['quantity'] - 1);
                          }
                        },
                      ),
                      Text(item['quantity'].toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          updateQuantity(index, item['quantity'] + 1);
                        },
                      ),
                    ],
                  ),
                  // Remove button
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      removeItem(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
