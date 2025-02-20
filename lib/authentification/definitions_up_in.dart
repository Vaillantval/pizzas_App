import 'package:firebase_auth/firebase_auth.dart';

//creer le 26/08/2024, Vaillant Valcin
class FireBaseAuthentificationService{

  FirebaseAuth _Auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword (String email, String password) async{
    try
    {
      UserCredential credential = await _Auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch(e) {
      print("Il y a une erreur");
    }
    return null;
  }

  Future<User?> signinWithEmailAndPassword (String email, String password) async{
    try
    {
      UserCredential credential = await _Auth.signInWithEmailAndPassword (email: email, password: password);
      return credential.user;
    } catch(e) {
      print("Il y a une erreur");
    }
    return null;
  }
}

//cree le 02/10/2024
// on va verifier si l utilisateur actuel est deja sign in
// (on va devoir finaliser tout ca)

/*
class AuthChekPage extends StatefulWidget {
  AuthChekPage({super.key});

  @override
  State<AuthChekPage> createState() => _AuthChekPageState();
}

class _AuthChekPageState extends State<AuthChekPage> {

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    /*if (user != null) {
      // L'utilisateur est connecté
      return CircularProgressIndicator();
    } else */
      // L'utilisateur n'est pas connecté
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.green,
        //Theme.of(context).colorScheme.inversePrimary,

        title: const Text('Login'),
      ),
      body: //SingleChildScrollView
      Center(
        // padding: const EdgeInsets.all(15.0),
        child: Column(

          children: [
            Text('Attendez un instant svp?'),
            CircularProgressIndicator(),

          ],
        )

      ),

    );
  }
}

 */