import 'package:flutter/material.dart';
import 'package:icecream_store/cart/modify_cart.dart';

class AdminPortal extends StatefulWidget {
  const AdminPortal({super.key});

  @override
  AdminPortalState createState() => AdminPortalState();
}

class AdminPortalState extends State<AdminPortal> {
  List<String> userNames = [
    'Binod',
    'Sourav',
    'Shreyas',
    'Sumit',
    'Tina',
    'Rina',
    'Suhana',
    'Lucifer'
  ];

  List<String> filteredUserNames = [];

  TextEditingController searchController = TextEditingController();

  // Function to filter users based on the search query
  void filterUsers() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredUserNames = userNames
          .where((userName) => userName.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    filteredUserNames = userNames;
    searchController.addListener(filterUsers);
  }


  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Requests',
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search User',
                  hintText: 'Search by name...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                style: TextStyle(fontSize: 16),
              ),
            ),

            // Display filtered user cards
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(filteredUserNames.length, (index) {
                    final userName = filteredUserNames[index];
                    return UserRequestCard(
                        userName: userName, requestCount: index + 1);
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserRequestCard extends StatefulWidget {
  final String userName;
  final int requestCount;

  const UserRequestCard({
    super.key,
    required this.userName,
    required this.requestCount,
  });

  @override
  UserRequestCardState createState() => UserRequestCardState();
}

class UserRequestCardState extends State<UserRequestCard> {
  int currentRequestCount = 0;

  @override
  void initState() {
    super.initState();
    currentRequestCount = widget.requestCount;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // User Name and Request Count
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Requests: ',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '$currentRequestCount',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrangeAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Row for Action Buttons and Three Dots
            Row(
              children: [
                // Accept Button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentRequestCount++;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: Text(
                    'Accept',
                    style: TextStyle(
                      color: Colors.white, 
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // Reject Button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentRequestCount--;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: Text(
                    'Reject',
                    style: TextStyle(
                      color: Colors.white, 
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // Three Dots for More Options
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'modify') {
                      // Navigate to ModifyCart page when selected
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ModifyCart(), 
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'modify',
                      child: Text('Modify Cart'),
                    ),
                  ],
                  child: Icon(Icons.more_vert),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
