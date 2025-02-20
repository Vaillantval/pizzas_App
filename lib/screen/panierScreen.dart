import 'package:ackapizza_final/screen/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

///Valcin Vaillant
///page ou l'on presente les pizzas de l'entreprise

class panierPage extends StatefulWidget {
  const panierPage(
      {super.key,
      required this.user,
      required this.username,
      required this.numberphone});

  final User? user;
  final String username;
  final String numberphone;

  @override
  State<panierPage> createState() => _panierPageState();
}

class _panierPageState extends State<panierPage>
    with SingleTickerProviderStateMixin {
  // fonction pour modifier les donner sur firebase dans le panier

  List<String> COMMAND = [];
  bool ifdeleted = false;

  Future<void> _updatecommande({
    required int new_quantity,
    required int new_price,
    required String new_size,
    required String idPizza,
    required int discount,
  }) async {
    CollectionReference _collection = FirebaseFirestore.instance
        .collection("usersglobal")
        .doc(widget.user!.email)
        .collection('panier');

    int updatedPrice = new_price * new_quantity;
    int finalPrice = updatedPrice - ((updatedPrice * discount) / 100).round();

    await _collection.doc(idPizza).update({
      'size': new_size,
      'somme': finalPrice,
      'nombre': new_quantity,
      'datedujour': Timestamp.now(),
    });

    //setState(() {});
  }

  @override
  void initState() {
    super.initState();

    /* _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this)
          ..repeat(reverse: true);
    _widthAnimation =
        Tween<double>(begin: 300, end: MediaQuery.of(context).size.width)
            .animate(_controller)
          ..addListener(() {
            setState(() {});
          });
    _heightAnimation = Tween<double>(begin: 40, end: 50).animate(_controller)
      ..addListener(() {
        setState(() {});
      });*/
  }

  // User? user = FirebaseAuth.instance.currentUser;
  // late int? montant;

  @override
  void dispose()  {
    // TODO: implement dispose
    //_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          children: [
            Image.asset('assets/images/pizza_logo.png', scale: 2.3),
            const SizedBox(width: 20),
            const Text(
              'PANIER',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.shopping_cart,
              color: Colors.orange,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          const Text('HTG changement'),
          IconButton(
            onPressed: () =>
                _lancerwhatsapp(message: 'Bonjour, je veux acheter une pizza'),
            icon: const Icon(
              FontAwesomeIcons.whatsapp,
              color: Colors.green,
            ),
            tooltip: 'whatsapp',
          ), //const SizedBox(width: 20),
        ],
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Expanded(
            child: _streampanier(),
          ),

          Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  //_widthAnimation.value,
                  height: 50,
                  //_heightAnimation.value,
                  child: TextButton(
                    onPressed: () {
                      //on passe une commande
                      if (COMMAND.isNotEmpty) {
                        _alerteCommande(context, commandes: COMMAND);
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Row(
                            children: [
                              Text('Le panier est vide'),
                              Icon(
                                Icons.send_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                            top: 15.0,
                            // Ajustez cette valeur selon vos besoins
                            left: 10.0,
                            right: 10.0,
                          ),
                          backgroundColor: Colors.orange,
                          duration: Duration(seconds: 3),
                          elevation: 20.0,
                        ));
                      }
                    },
                    style: TextButton.styleFrom(
                        elevation: 3.0,
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text(
                      "Vider le Panier",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    // ),
                  )))
          // }),
        ],
      )),
    );
  }

  Widget _streampanier() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("usersglobal")
          .doc(widget.user!.email)
          .collection("panier")
          //.orderBy("datedujour")
          .snapshots(),
      // .orderBy('datedujour', descending: true)
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Erreur'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Pas de Pizza dans le panier"));
        } else {
          List<dynamic> pizzass = [];
          snapshot.data!.docs.forEach((element) {
            pizzass.add(element);
          });
          COMMAND.clear();
          return ListView.builder(
              reverse: false,
              itemCount: pizzass.length,
              itemBuilder: (context, index) {
                final commande = pizzass[index];
                final picture = commande['picture'];
                final pizzaName = commande['name'];
                final sommeFinale = commande['somme'];
                final priceMed = commande['priceMed'];
                final price = commande['price'];
                final pizzaId = commande['IdPanier'];
                final priceSmal = commande['priceSmal'];
                final priceLarg = commande['priceLarg'];
                final size = commande['size'];
                final nombre = commande['nombre'];
                final discount = commande['discount'];
                String valeurs =
                    "${index + 1}- $pizzaName: $nombre Unité(s)  \n Size:$size  " +
                        "montant total: HTG $sommeFinale \n";

                COMMAND.add(valeurs);

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(3, 3),
                          blurRadius: 5)
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    child: Column(
                      children: <Widget>[
                        /*Expanded(
                        child: */
                        ListTile(
                          onTap: () {
                            // pour embellir, on peut afficher la description du pizza
                          },
                          leading: CircleAvatar(
                            //modifie le scale pour la grosseur de l image
                            child: Image.network(
                              picture,
                              // scale: 4,
                            ),
                          ),
                          title: Text("$pizzaName: $nombre Unité(s)"),
                          subtitle: Text("HTG $sommeFinale"),
                        ),
                        //   ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    //a verifier

                                    COMMAND.clear();
                                    if (nombre > 1) {
                                      _updatecommande(
                                          new_quantity: nombre - 1,
                                          new_price: price,
                                          new_size: size,
                                          idPizza: pizzaId,
                                          discount: discount);
                                    }
                                    setState(() {});
                                  },
                                ),
                                Text(
                                  '$nombre',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    //a verifier
                                    COMMAND.clear();
                                    _updatecommande(
                                        new_quantity: nombre + 1,
                                        new_price: price,
                                        new_size: size,
                                        idPizza: pizzaId,
                                        discount: discount);
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                ChoiceChip(
                                  label: const Text('S'),
                                  selected: size == 'S',
                                  onSelected: (bool selected) {
                                    // setState(() {
//a verifier
                                    COMMAND.clear();
                                    _updatecommande(
                                        new_quantity: 1,
                                        new_price: priceSmal,
                                        new_size: 'S',
                                        idPizza: pizzaId,
                                        discount: discount);
                                    setState(() {});
                                  },
                                ),
                                const SizedBox(width: 10),
                                ChoiceChip(
                                  label: const Text('M'),
                                  selected: size == 'M',
                                  onSelected: (bool selected) {
                                    //a verifier
                                    COMMAND.clear();
                                    _updatecommande(
                                        new_quantity: 1,
                                        new_price: priceMed,
                                        new_size: 'M',
                                        idPizza: pizzaId,
                                        discount: discount);
                                    setState(() {});
                                  },
                                ),
                                const SizedBox(width: 10),
                                ChoiceChip(
                                  label: const Text('L'),
                                  selected: size == 'L',
                                  onSelected: (bool selected) {
//a verifier
                                    COMMAND.clear();
                                    _updatecommande(
                                        new_quantity: 1,
                                        new_price: priceLarg,
                                        new_size: 'L',
                                        idPizza: pizzaId,
                                        discount: discount);
                                    //updatePrice();
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 160,
                          height: 40,
                          child: TextButton(
                            onPressed: () {
                              //a verifier

                              _alerteDELLCart(context, pizzaId: pizzaId);
                              setState(() {
                                if (ifdeleted) COMMAND.remove(valeurs);
                              });
                            },
                            style: TextButton.styleFrom(
                                elevation: 3.0,
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: const Text(
                              "Retirer du panier",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        }
      },
    );
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

  ///---------------------------------------------
  _alerteDELLCart(context, {required String pizzaId}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Icon(Icons.add_shopping_cart),
          content: const Text(
            'Retirer du panier?',
            style: TextStyle(fontSize: 15),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Cancel');
                ifdeleted = false;
              },
              child: const Text(
                'Non',
                style: TextStyle(fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Row(
                    children: [
                      Text('Pizza retirée du panier'),
                      Icon(
                        Icons.remove_shopping_cart,
                        color: Colors.orange,
                        size: 20,
                      ),
                    ],
                  ),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 3),
                  elevation: 10.0,
                ));

                await FirebaseFirestore.instance
                    .collection("usersglobal")
                    .doc(widget.user!.email)
                    .collection('panier')
                    .doc(pizzaId)
                    .delete();

                setState(() {});
                Navigator.pop(context);
              },
              child: const Text(
                'Oui',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }

  ///---------------------------------------------
  void _alerteCommande(context, {required List<String> commandes}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Icon(Icons.send_and_archive),
          content: const Text(
            'Vider le panier?',
            style: TextStyle(fontSize: 15),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text(
                'Non',
                style: TextStyle(fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Row(
                    children: [
                      Text('Commande effectuée ☺'),
                      Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 3),
                  elevation: 10.0,
                ));

                String nom = widget.username;
                List<String> ids = [nom, Timestamp.now().toString()];
                ids.sort();
                String IdCommande = ids.join('_');

                await FirebaseFirestore.instance
                    .collection("commandes")
                    .doc(IdCommande)
                    .set({
                  'idcommande': IdCommande,
                  'iduser': widget.user!.uid,
                  'username': widget.username,
                  'adm': false,
                  'timestamp': Timestamp.now(),
                  'deliver': false,
                  'email': widget.user!.email,
                  'numero': widget.numberphone,
                  'commande': commandes.toString(),
                });

                await deleteAllDocumentsInCollection(
                    "usersglobal/${widget.user!.email}/panier");
                ifdeleted = true;
                setState(() {});
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(user: widget.user)));
              },
              child: const Text(
                'Oui',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }

  ///---------------------------------------------------------
  Future<void> deleteAllDocumentsInCollection(String collectionPath) async {
    // Obtenir une référence à la collection
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(collectionPath);

    // Récupérer tous les documents de la collection
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Boucle à travers chaque document et supprimer individuellement
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    print(
        "Tous les documents dans la collection $collectionPath ont été supprimés.");
  }
}
