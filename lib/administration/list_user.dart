import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../chatServices/newChatPage.dart';

class liste_utilisateur extends StatefulWidget {
  liste_utilisateur({
    super.key,
  });

  @override
  State<liste_utilisateur> createState() => _liste_utilisateurState();
}

class _liste_utilisateurState extends State<liste_utilisateur> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        //Theme.of(context).colorScheme.inversePrimary,

        title: Row(
          children: [
            const Text('Liste Des Clients en ligne'),
            const SizedBox(width: 5),
            Image.asset('assets/images/pizza_logo.png', scale: 3),
          ],
        ),
      ),
      body: Center(
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("usersglobal").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text(' Erreur'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData) {
              return const Text("Pas encore d'utilisateur");
            }

            List<dynamic> userAcka = [];
            snapshot.data!.docs.forEach((element) {
              userAcka.add(element);
            });
            return ListView.builder(
                itemCount: userAcka.length,
                itemBuilder: (context, index) {
                  final utilisat = userAcka[index];
                  final name = utilisat['username'];
                  final email = utilisat['email'];
                  final numero = utilisat['numero'];
                  final id = utilisat['id'];
                  //  final token = utilisat['token'];
                  bool adm = utilisat['adm'];
                  final ifadministrateur = adm
                      ? 'Retirer comme administrateur'
                      : 'Nommer administrateur';
                  //  if (email != FirebaseAuth.instance.currentUser!.email)
                  return Container(
                      padding: const EdgeInsets.all(15.0),
                      margin: const EdgeInsets.all(22.0),
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            //Colors.grey
                            color: Color.fromARGB(225, 95, 27, 3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            name,
                            style: const TextStyle(fontSize: 22.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: adm
                              ? const Text(
                                  'Statut: Administrateur',
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold),
                                )
                              : const Text(
                                  'Statut: Client',
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Email: $email',
                              style: const TextStyle(fontSize: 22.0),
                            )),
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Téléphone: $numero',
                              style: const TextStyle(fontSize: 22.0),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: ElevatedButton.icon(
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.orange),
                                foregroundColor:
                                    WidgetStatePropertyAll(Colors.white)),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => newChatUI(
                                          name1: name,
                                          admSender: true,
                                          receiverId: id,
                                          Sendername: 'Administrateur',
                                          admReceiver: false,
                                        ))),
                            label: const Text("Ecrire l'utilisateur"),
                            icon: const Icon(Icons.sms),
                          ),
                        ),

                        /****Vaillant Valcin*****/
                        // bnh on met des gens oncall
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () async {
                                  !adm
                                      ? _alertedialdelete(index: index)
                                      : ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                          content: Text(
                                              "Vous ne pouvez pas bloquer un adm ☻"),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 3),
                                          elevation: 20.0,
                                        ));
                                },
                                label: const Text('Bloquer Cet Utilisateur'),
                                icon: const Icon(Icons.delete_forever),
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          // alerte==true? Colors.red:
                                          Colors.orange),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                      Icons.perm_contact_cal_outlined)),
                              Text(
                                ifadministrateur,
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Transform.scale(
                                scale: 1.5,
                                child: Checkbox(
                                    value: adm,
                                    onChanged: (bool? value) async {
                                      setState(() async {
                                        adm = value!;
                                        //  oui, il faut modifier la valeur de adm dans la base
                                      });

                                      await FirebaseFirestore.instance
                                          .collection('usersglobal')
                                          .doc(email)
                                          .update({
                                        'adm': adm,
                                      });
                                    }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        /****Vaillant Valcin*****/
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () async =>
                                      _launchDialer(index: index),
                                  icon: const Icon(
                                    Icons.call,
                                  )),
                              const SizedBox(
                                width: 20,
                              ),
                              IconButton(
                                  onPressed: () => _lancerwhatsapp(
                                      index: index, message: 'Bonjour'),
                                  icon: const FaIcon(FontAwesomeIcons.whatsapp,
                                      color: Colors.green)),
                              const SizedBox(
                                width: 20,
                              ),
                              IconButton(
                                  onPressed: () => _launchEmail(
                                      index: index,
                                      message: 'Bonjour/Bonsoir, '),
                                  icon: const Icon(Icons.mail_rounded)),
                            ],
                          ),
                        ),
                      ]));
                });
          },
        ),
      ),
    );
  }

  //ALERTE DIALOGUE POUR SUPPRIMER UN USER // novembre 2024/ Valcin Vaillant
  void _alertedialdelete({required int index}) async {
    const SizedBox(
      height: 100,
    );

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Remove '),
            content: const Text('Remove this User?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  List<String> ids = await getDocumentIds();
                  FirebaseFirestore.instance
                      .collection('usersglobal') // TODO a modifier
                      .doc(ids[index])
                      .delete();
                  Navigator.pop(context);
                },
                child: const Text('Yes'),
              ),
            ],
          );
        });
  }

  //ALERTE DIALOGUE POUR METTRE ONCALL UN UTILISATEUR
  void _launchDialer({
    required int index,
  }) async {
    var valeurChamp;
    List<String> ids = await getDocumentIds();
    await FirebaseFirestore.instance
        .collection('usersglobal') // TODO a modifier
        .doc(ids[index])
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        // Accède au champ souhaité
        valeurChamp = snapshot.get('numero');
      } else {
        print('Document non trouvé');
      }
    });
    final Uri telUri = Uri(
      scheme: 'tel',
      path: valeurChamp,
    );

    if (await canLaunchUrl(Uri.parse(telUri.toString()))) {
      await launchUrl(Uri.parse(telUri.toString()));
    } else {
      throw 'Could not launch $telUri';
    }
  }

  void _lancerwhatsapp({required int index, required String message}) async {
    var phone;
    List<String> ids = await getDocumentIds();
    await FirebaseFirestore.instance
        .collection('usersglobal') // TODO a modifier
        .doc(ids[index])
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

  //envoyer un email a cet user precis
  void _launchEmail({required int index, required String message}) async {
    var email;
    List<String> ids = await getDocumentIds();
    await FirebaseFirestore.instance
        .collection('usersglobal')
        .doc(ids[index])
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        // Accède au champ souhaité
        email = snapshot.get('email');
      } else {
        print('Document non trouvé');
      }
    });
    final Uri params = Uri(
      scheme: 'mailto',
      path: email, // TODO a modifier
      query: message, // Ajoutez les paramètres ici
    );

    var url = params.toString();
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<List<String>> getDocumentIds() async {
    // on va prendre l'id de tous les documents dans ma collections des cas_sop

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('usersglobal').get();
    List<String> docIds = querySnapshot.docs.map((doc) => doc.id).toList();

    return docIds;
  }
}
