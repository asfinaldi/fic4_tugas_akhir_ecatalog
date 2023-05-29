import 'package:flutter/material.dart';
import 'package:platzi_fake_store_app/presemtation/pages/login_page.dart';

class SplashPage extends StatelessWidget {
  static const String routeName = '/splash-page';
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
            height: 200.0,
            ),
            Image.asset(
              "assets/images/logos.png",
              width: 300.0,
              height: 300.0,
              fit: BoxFit.fill,
            ),
            const SizedBox(
            height: 50.0,
            ),
            InkWell(
              onTap: (){
                    Navigator.pushNamed(context, LoginPage.routeName);
              },
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.blue
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
