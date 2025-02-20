import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'list_user_for_chat.dart';
import 'newChatPage.dart';
import 'user_title.dart';
import 'package:intl/intl.dart';

class display_userspage extends StatefulWidget {
  display_userspage({
    super.key,
    required this.admin,
    required this.name3,
    required this.espace,
    required this.actuel,
  });

  // il peut ne pas y avoir de nom
  final bool admin;
  final String name3;
  final String espace;
  final bool actuel;

  //

  @override
  State<display_userspage> createState() => _display_userspageState();
}

class _display_userspageState extends State<display_userspage> {
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool deja = false;
  String id_adm = '';

  void fechadmin() async {
    setState(() {});
    //TODO arange cette fonction
    DocumentSnapshot admdoc = await FirebaseFirestore.instance
        .collection('administrateurs')
        .doc("idDocument")
        .get();
    setState(() {
      id_adm = admdoc['id'];
    });
    //verifie si c est le premier admin qu on prend
  }

  Future<void> fetchFirstField(String collectionPath, String documentId) async {
    // Obtenir une référence au document
    DocumentReference documentRef =
        FirebaseFirestore.instance.collection(collectionPath).doc(documentId);

    // Récupérer le document
    DocumentSnapshot documentSnapshot = await documentRef.get();

    if (documentSnapshot.exists) {
      // Accéder aux données du document sous forme de Map
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      if (data.isNotEmpty) {
        // Obtenir la première paire clé-valeur
        String firstKey = data.keys.first;

        //ce que je veux:
        ///-------------------------------------
        id_adm = data[firstKey];

        ///--------------------------------------------------------------------
        // Afficher le premier champ
        // print('Premier champ: $firstKey, Valeur: $firstValue');
      } else {
        print('Le document est vide.');
      }
    } else {
      print('Document non trouvé');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFirstField("administrateurs", "idDocument");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commandes'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          // put some actions
          Image.asset('assets/images/pizza_logo.png', scale: 2.4),
        ],
      ),

      body: _UserList(context),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: 'Home',
        backgroundColor: Colors.grey,
        child: const Icon(Icons.home_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _UserList(BuildContext context) {
    return StreamBuilder(
      stream: _chatService.getUser(quelEspace: widget.espace),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (!snapshot.hasData) {
          return const Text("Pas de commandes");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListitem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListitem(
      Map<String, dynamic> userData, BuildContext context) {
    String UserName = userData['username'];
    String time = userData['timestamp'].toString();
    List<String> ids = [UserName, time];
    ids.sort();
    String IdCommande = ids.join('_');
    if (userData['email'] == _auth.currentUser!.email &&
        (widget.actuel == true)) {
      //a verifier
      return UserTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => newChatUI(
                        name1: "Administrateur(trice)",
                        admSender: widget.admin,
                        receiverId: id_adm,
                        Sendername: widget.name3,
                        admReceiver: true,
                      )));
        },
        text: userData['username'] + ' (Vous)',
        date: DateFormat.yMMMMd('en_US')
            .add_jm()
            .format(userData['timestamp'].toDate()),
        message: userData['commande'],
        ifdeliver: userData['deliver'],
        numero: userData['numero'],
        ifadmin: widget.admin,
        idCommande: IdCommande,
      );
    } else if (widget.actuel == false) {
      return UserTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => newChatUI(
                        name1: userData['username'],
                        admSender: widget.admin,
                        receiverId: userData['iduser'],
                        Sendername: widget.name3,
                        admReceiver: userData['adm'],
                      )));
        },
        text: userData['username'],
        date: DateFormat.yMMMMd('en_US')
            .add_jm()
            .format(userData['timestamp'].toDate()),
        message: userData['commande'],
        ifdeliver: userData['deliver'],
        numero: userData['numero'],
        ifadmin: widget.admin,
        idCommande: IdCommande,
      );
    } else {
      return const Text(' ');
    }
  }
/*_launchDialer({
    required var nomberphone,
  }) async {
    //  var valeurChamp;

    final Uri telUri = Uri(
      scheme: 'tel',
      path: nomberphone,
    );

    if (await canLaunchUrl(Uri.parse(telUri.toString()))) {
      await launchUrl(Uri.parse(telUri.toString()));
    } else {
      throw 'Could not launch $telUri';
    }
  }*/
}
