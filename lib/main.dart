import 'package:flutter/material.dart';
import 'package:icecream_store/cart/modify_cart.dart';
import 'package:icecream_store/pages/admin_portal/admin_portal.dart';
import 'package:icecream_store/pages/admin_portal/welcome_admin.dart';
import 'package:icecream_store/pages/login.dart';
import 'package:icecream_store/pages/order_confirmation/order_confirmation_page.dart';
import 'package:icecream_store/pages/registration.dart';
import 'package:icecream_store/pages/user_portal/user.dart';
import 'package:icecream_store/pages/user_portal/welcome_user.dart';

void main() {
  runApp(IcecreamStore());
}

class IcecreamStore extends StatelessWidget {
  const IcecreamStore({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ice Cream Store',
      initialRoute: '/registration', //initial route
      routes: {
        '/registration': (context) => const Registration(),
        '/login': (context) => const Login(), 
        '/admin':(context) => const Admin(),
        '/user':(context) => const User(),
        '/adminPortal':(context) => const AdminPortal(), 
        '/welcomeUser': (context) => const WelcomeUser(),
        '/modifyCart': (context) => const ModifyCart(),
        '/orderConfirmation': (context) => const OrderConfirmationPage(),
      },
    );
  }
}
