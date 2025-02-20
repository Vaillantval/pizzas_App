import 'package:ackapizza_final/administration/adminScreen.dart';
import 'package:ackapizza_final/chatServices/display_users.dart';
import 'package:ackapizza_final/screen/detail_screen.dart';
import 'package:ackapizza_final/screen/panierScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../local_notification.dart';
import '../macro.dart';

///Valcin Vaillant
///page ou l'on presente les pizzas de l'entreprise

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.user});

  final User? user;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool change = true;
  var nombre;
  late AnimationController _controller;
  late Animation<double> _grosseur;
  late bool admin;
  bool demandAdm = false;
  bool deja = false;
  String nomUser = '';
  String numberphone = '';
  String id1 = '';

  //User? widget.user = FirebaseAuth.instance.currentUser;

  Future<void> fechUser() async {
    if (!deja) {
      setState(() {
        demandAdm = true;
      });
      try {
        DocumentSnapshot admdoc = await FirebaseFirestore.instance
            .collection('usersglobal')
            .doc(widget.user!
                .email) // Remplace 'user123' par l'ID de l'utilisateur actuel
            .get();

        setState(() {
          admin = admdoc['adm'];
          nomUser = admdoc['username'];
          numberphone = admdoc['numero'];
          id1 = admdoc['id'];
          demandAdm = false;
          deja = true;
        });
      } catch (e) {
        setState(() {
          demandAdm = false;
        });
        print("Erreur lors de la récupération des données : $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initSetup();
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this)
          ..repeat(reverse: true);
    _grosseur = Tween<double>(begin: 15, end: 30).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  void initSetup() async {
    await fechUser();
    NotificationService.checkAndUpdateToken(
      ifAdminis: admin,
      nomAdmin: nomUser,
      idAdm: id1,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

/*
  @override
  void initState() {
    super.initState();
    fechUser();
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this)
          ..repeat(reverse: true);
    _grosseur = Tween<double>(begin: 15, end: 30).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
   //NotificationService.checkAndUpdateToken(ifAdminis: admin, nomAdmin: nomUser, idAdm: id1,);

    /* CollectionReference _collection = FirebaseFirestore.instance
        .collection("usersglobal")
        .doc(widget.user!.email)
        .collection('panier');
    if (_collection.parameters.keys == 'nombre') {
      nombre = nombre! + _collection.parameters.values;
    }
    ;
    nombre = _collection.count() as int?;
    setState(() {});*/

    /* snapshot.data!.docs.forEach((element) {
          casSop.add(element);
        });*/
  }*/

/*
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _grosseur = Tween<double>(begin: 15, end: 30).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Row(
            children: [
              Image.asset('assets/images/pizza_logo.png', scale: 2.35),
              const SizedBox(width: 8),
              const Text(
                'ACKAPIZZA',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
              )
            ],
          ),
          actions: [
            //TODO il faudrait ajouter l indice qui montre le nombre de produit mis dans le panier par cet utilisateur, et ce dès l entrée dans cette page
            IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => panierPage(
                            user: widget.user,
                            username: nomUser,
                            numberphone: numberphone,
                          ))),
              icon: const Icon(
                CupertinoIcons.cart,
                color: Colors.orange,
              ),
            ),
            IconButton(
              onPressed: () => _lancerwhatsapp(
                  message: 'Bonjour, je voudrais acheter une pizza svp'),
              icon: const Icon(
                FontAwesomeIcons.whatsapp,
                color: Colors.green,
              ),
              tooltip: 'whatsapp',
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(widget.user!.email!),
                accountEmail: const Text(''),
                currentAccountPicture: const CircleAvatar(
                  child: ClipOval(child: Icon(Icons.person)

                      /*Image.network(
                      widget.user!.photoURL!,
                      scale: 2.5,
                    ),*/
                      ),
                ),
                decoration: const BoxDecoration(
                  //   color: Colors.green,
                  gradient: LinearGradient(
                    colors: [
                      Colors.redAccent,
                      Colors.yellow,
                      Colors.white
                      // Colors.white,
                    ],
                    end: Alignment.topRight,
                    begin: Alignment.bottomLeft,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Accueil'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.shopping_cart,
                  color: Colors.orange,
                ),
                title: const Text(
                  'Panier',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => panierPage(
                              user: widget.user,
                              username: nomUser,
                              numberphone: numberphone,
                            ))),
              ),
              ListTile(
                leading: const Icon(
                  color: Colors.brown,
                  FontAwesomeIcons.boxArchive,
                ),
                title: const Text('Vos Commandes & Achats'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => display_userspage(
                                espace: 'commandes',
                                admin: admin,
                                name3: nomUser,
                                actuel: true,
                              )));
                },
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.green,
                ),
                title: const Text('Contact'),
                onTap: () {
                  _lancerwhatsapp(
                      message: 'Bonjour, je voudrais acheter une pizza svp');
                },
              ),
              ListTile(
                leading: const Icon(Icons.keyboard_double_arrow_right_sharp),
                title: const Text('SignOut'),
                onTap: () {
                  Navigator.pop(context);
                  //TODO a modifier
                  FirebaseAuth.instance.signOut();

                  // a verifier
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Signing Out...")));
                  Navigator.pop(context);
                },
              ),
              const SizedBox(
                height: 70,
              ),
              if (!demandAdm)
                ListTile(
                  leading: const Icon(
                    Icons.admin_panel_settings,
                  ),
                  title: const Text('Administration'),
                  onTap: () {
                    //if (!deja) fechUser();
                    if (admin) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const espaceAdministrateur(
                                  nomUser: 'Administrateur')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Vous n'est pas administrateur ☺"),
                        backgroundColor: Colors.orange,
                        duration: Duration(seconds: 2),
                        elevation: 10.0,
                        behavior: SnackBarBehavior.floating,
                      ));
                    }
                  },
                )
              else
                const ListTile(
                  leading: CircularProgressIndicator(),
                  title: Text("recherche admin..."),
                ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("pizzas").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Text("Pas de Pizzas disponible"));
              } else {
                List<dynamic> pizza = [];
                snapshot.data!.docs.forEach((element) {
                  pizza.add(element);
                });

                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 9 / 16),
                    itemCount: pizza.length,
                    itemBuilder: (context, index) {
                      final utilisat = pizza[index];

                      final String pizzaId = utilisat['pizzaId'];
                      final String picture = utilisat['picture'];
                      final int calories = utilisat['calories'];
                      final String name = utilisat['name'];
                      final String description = utilisat['description'];
                      final int priceSmal = utilisat['priceSmal'];
                      final int priceMed = utilisat['priceMed'];

                      //final int priceLarg = utilisat['priceLarg'];
                      final bool isVeg = utilisat['isVeg'];
                      final int priceLarg = utilisat['priceLarg'];
                      final int discount = utilisat['discount'];
                      return Material(
                        elevation: 4,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                        pizzaId: pizzaId,
                                        //pizza[index]['pizzaId'],
                                        picture: picture,
                                        // pizza[index]['picture'],
                                        calories: calories,
                                        //pizza[index]['calories'],
                                        name: name,
                                        //laisse expres
                                        description: description,
                                        //pizza[index]
                                        //   ['description'],
                                        priceSmal: priceSmal,
                                        //pizza[index]['priceSmal'],
                                        priceMed: priceMed,
                                        //pizza[index]['priceMed'],
                                        priceLarg: priceLarg,
                                        //pizza[index]['priceLarg'],
                                        discount: discount,
                                        //pizza[index]['discount'],
                                        user: widget.user,
                                        username: nomUser,
                                        numberphone: numberphone,
                                        modifierPizza: false,
                                      ))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Image.network(picture),
                              ),

                              //   SizedBox(height: 5,),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color:
                                              isVeg ? Colors.green : Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        child: Text(
                                          isVeg ? "VEG" : "NON-VEG",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ),
                                    MyMacroWidget(
                                      title: "Calories",
                                      value: calories,
                                      icon: FontAwesomeIcons.fire,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Text(
                                  description,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "HTG ${priceMed - (priceMed * (discount) / 100)}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "HTG $priceMed.00",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade500,
                                                fontWeight: FontWeight.w700,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailsScreen(
                                                    pizzaId: pizzaId,
                                                    //pizza[index]['pizzaId'],
                                                    picture: picture,
                                                    // pizza[index]['picture'],
                                                    calories: calories,
                                                    //pizza[index]['calories'],
                                                    name: name,
                                                    //laisse expres
                                                    description: description,
                                                    //pizza[index]
                                                    //   ['description'],
                                                    priceSmal: priceSmal,
                                                    //pizza[index]['priceSmal'],
                                                    priceMed: priceMed,
                                                    //pizza[index]['priceMed'],
                                                    priceLarg: priceLarg,
                                                    //pizza[index]['priceLarg'],
                                                    discount: discount,
                                                    //pizza[index]['discount'],
                                                    user: widget.user,
                                                    username: nomUser,
                                                    numberphone: numberphone,
                                                    modifierPizza: false,
                                                  )));
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.cart_fill_badge_plus,
                                      color: Colors.orange,
                                    )),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              }
            },
          ),
        ),
        floatingActionButton: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FloatingActionButton.extended(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => panierPage(
                              user: widget.user,
                              username: nomUser,
                              numberphone: numberphone,
                            ))),
                icon: Icon(
                  Icons.shopping_cart_rounded,
                  shadows: [
                    const Shadow(
                      color: Colors.grey,
                    )
                  ],
                  size: _grosseur.value,
                ),
                label: const Text('Panier'),
                backgroundColor: Colors.white,
                foregroundColor: Colors.orange,
                elevation: 200,
              );
            }));
  }

  void _lancerwhatsapp({required String message}) async {
    // arange ca dans firestore
    String? phone;
    // List<String> ids = await getDocumentIds();
    await FirebaseFirestore.instance
        .collection('contact') // TODO a modifier
        .doc('whatsapp')
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        // Accède au champ souhaité
        phone = snapshot.get('numero');
      } else {
        print('Document non trouvé');
      }
    });

    final whatsappUrl =
        'whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}';

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      throw 'Impossible d\'ouvrir WhatsApp';
    }
  }
}
