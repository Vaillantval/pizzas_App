import 'dart:ui';
import 'package:flutter/material.dart';

import '../authentification/SignIn.dart';
import '../authentification/signUp.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  late AnimationController _controller;
  late Animation<double> _sizeLettre;

  //Valcin VAILLANT, février 2025

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    tabController.dispose();
  }

  @override
  void initState() {
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _sizeLettre = Tween<double>(begin: 9, end: 16).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sizeLettre = Tween<double>(begin: 9, end: 16).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: const AlignmentDirectional(20, -1.2),
                child: Container(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.redAccent,
                        Colors.yellow,
                        // Colors.white,
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(2.7, -1.2),
                child: Container(
                  height: MediaQuery.of(context).size.width / 1.3,
                  width: MediaQuery.of(context).size.width / 1.3,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.red),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                child: Container(),
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.8,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: TabBar(
                          controller: tabController,
                          unselectedLabelColor: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                          labelColor: Theme.of(context).colorScheme.onSurface,
                          tabs: const [
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: TabBarView(
                        controller: tabController,
                        children: [
                          Column(
                            children: [
                              // ou genlè pa dako non?...☻☺
                              const SignInScreen(),
                              tabController.index == 0
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Row(
                                        children: [
                                          TextButton(
                                            child: Text(
                                              "⚈  Pas encore de compte?",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                  fontSize: 12),
                                            ),
                                            onPressed: () {
                                              tabController.index = 1;
                                            },
                                          ),
                                          AnimatedBuilder(
                                              animation: _controller,
                                              builder: (context, child) {
                                                return TextButton(
                                                  child: Text(
                                                    'Cliquez ici',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize:
                                                            _sizeLettre.value,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  onPressed: () {
                                                    tabController.index = 1;
                                                  },
                                                );
                                              })
                                        ],
                                      ))
                                  : const SizedBox(
                                      height: 1,
                                    ),
                            ],
                          ),
                          const SignUpScreen(),
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
