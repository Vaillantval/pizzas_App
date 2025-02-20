import 'package:ackapizza_final/screen/homeScreen.dart';
import 'package:ackapizza_final/screen/welcomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../local_notification.dart';

class firstcreen extends StatefulWidget {
  const firstcreen({super.key});

  @override
  State<firstcreen> createState() => _firstcreenState();
}

class _firstcreenState extends State<firstcreen>
    with SingleTickerProviderStateMixin {
  /* bool val = false;
  List<Map<String, dynamic>> dataList = [];
  String em = '', pas = '', nam = '';
  String numero = '';
  bool adm = false;
  List utilisateur = [];*/
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  late Animation<double> _heightAnimation;
  bool _isLoading = false;
  User? user=FirebaseAuth.instance.currentUser;

  // User? user = FirebaseAuth.instance.currentUser;

  void _startLoading() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(seconds: 8), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _isUser({required User? user}) {
    if (user != null)
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MyHomePage(user: user)));
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    // pour gagner du temps
    _isUser(user: user);
    NotificationService.init();
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this)
          ..repeat(reverse: true);
    _widthAnimation = Tween<double>(begin: 250, end: 275).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _heightAnimation = Tween<double>(begin: 55, end: 65).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    // _controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 1,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/pizza_pic.jpg",
              ),
              fit: BoxFit.cover,
              scale: 0.9,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(70)),
          ),
        ),
        const SizedBox(
          height: 8,
          width: 10,
        ),
        if (_isLoading) const CircularProgressIndicator(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            padding: const EdgeInsets.only(top: 40, bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.redAccent,
                  Colors.yellow,
                  // Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(70), topRight: Radius.circular(70)),
            ),
            child: Column(
              children: [
                // space
                const SizedBox(
                  height: 3,
                ),

                const Text(
                  '  Bienvenue chez: \n 🍕 AckaPizza 🍕',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    wordSpacing: 2,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Plongez dans un monde de délices où chaque part de pizza est une œuvre d\'art.'
                    ' préparées avec amour et passion. Votre voyage culinaire commence ici !',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Material(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () async {
                      // benh ouais juste pour patienter un peu

                      // _startLoading();
                      // BNH OUAIS IL FAUT VERIFIER SI L UTILISATEUR EST SIGN IN
                      if (user == null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WelcomeScreen()));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage(user: user)));
                      }
                    },
                    child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 60),
                              width: _widthAnimation.value,
                              height: _heightAnimation.value,
                              child: const Center(
                                child: Text(
                                  "Get Start",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold),
                                ),
                              ));
                        }),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    ));
  }
}
