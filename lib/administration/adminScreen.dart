import 'package:ackapizza_final/administration/add_new_produit.dart';
import 'package:ackapizza_final/administration/list_produits.dart';
import 'package:ackapizza_final/chatServices/display_users.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'list_user.dart';
import 'package:flutter/cupertino.dart';

class espaceAdministrateur extends StatefulWidget {
  const espaceAdministrateur({
    super.key,
    required this.nomUser,
  });

  final String nomUser;

  @override
  State<espaceAdministrateur> createState() => _espaceAdministrateurState();
}

class _espaceAdministrateurState extends State<espaceAdministrateur> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,

      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [Colors.red, Colors.orange, Colors.grey])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    ' Espace Administrateur ',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45),
                  ),
                  Icon(
                    Icons.admin_panel_settings,
                    color: Colors.black45,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(225, 95, 27, 3),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        )
                      ]),
                  child: Column(
                    children: [
                      Image.asset('assets/images/pizza_logo.png', scale: 2),
                    ],
                  ),
                  // TODO il y a des trucs a mettre ici
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
                child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                          shadowColor: Colors.grey,
                          elevation: 400,
                        ),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => display_userspage(
                                      admin: true,
                                      name3: widget.nomUser,
                                      espace: 'commandes',
                                      actuel: false,
                                    ))),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Liste des Commandes",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.double_arrow),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                          shadowColor: Colors.grey,
                          elevation: 400,
                        ),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => liste_utilisateur())),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Liste des utilisateurs",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.double_arrow),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                          shadowColor: Colors.grey,
                          elevation: 400,
                        ),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => const MyListeProducts())),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "La liste des produits disponibles",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.double_arrow),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                          shadowColor: Colors.grey,
                          elevation: 400,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) =>  add_product(IdPizza: "", ifmodif: false, pictureFile: XFile(""))));
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Ajouter un nouveau produit",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.double_arrow),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

//pour choisir quel type de code on a a modifier
}
