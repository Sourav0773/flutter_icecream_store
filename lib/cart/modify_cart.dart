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
        title: Text('Modify Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          var item = cartItems[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Item name and price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['name'],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('\$${item['price']}'),
                    ],
                  ),
                  Spacer(),
                  // Quantity adjuster
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (item['quantity'] > 1) {
                            updateQuantity(index, item['quantity'] - 1);
                          }
                        },
                      ),
                      Text(item['quantity'].toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          updateQuantity(index, item['quantity'] + 1);
                        },
                      ),
                    ],
                  ),
                  // Remove button
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
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
