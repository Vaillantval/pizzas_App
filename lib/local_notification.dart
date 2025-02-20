import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>().requestNotificationsPermission();
//static final IOSFlutterLocalNotificationsPlugin _iosFlutterLocalNotificationsPlugin= IOSFlutterLocalNotificationsPlugin();

  //Future <void> init() async

  static Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/pizza_logo');

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    //on abonne tous les users au topuc alluser pour notification firebase
    await messaging.subscribeToTopic("allUsers");

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: (id, title, body, payload) {});
    //pour android
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    //pour Ios

    await _notifications.initialize(
      initializationSettings,
      //onDidReceiveBackgroundNotificationResponse: ,
    );

//gerer les message pendant qu on utilise l application
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? appleNotification = message.notification?.apple;
      if (notification != null &&
          (android != null || appleNotification != null)) {
        await _notifications.show(0, notification.title, notification.body,
            await _notificationsDetails(),
            payload: 'HAH');
      }
    });
    //_iosFlutterLocalNotificationsPlugin.initialize(initializationSettings as DarwinInitializationSettings);
  }

//Notification simple
  static Future showNotifications(
      {int id = 0,
      required String? title,
      required String? body,
      required String? payload}) async {
    await _notifications.show(id, title, body, await _notificationsDetails(),
        payload: payload);
  }

//Notification par heure
  static Future showPeriodiqueNotifications(
      {int id = 0,
      required String? title,
      required String? body,
      required String? payload}) async {
    await _notifications.periodicallyShow(
        id, title, body, RepeatInterval.daily, await _notificationsDetails(),
        payload: payload);
  }

  //Notification par minutes
  static Future showPersistanteNotifications(
      {int id = 43,
      required String? title,
      required String? body,
      required String? payload}) async {
    await _notifications.periodicallyShow(id, title, body,
        RepeatInterval.everyMinute, await _notificationsDetails(),
        payload: payload);
  }

  //Notification par semaine
  static Future show_WeekNotifications1(
      {int id = 0,
      required String? title,
      required String? body,
      required String? payload}) async {
    await _notifications.periodicallyShow(
        id, title, body, RepeatInterval.weekly, await _notificationsDetails(),
        payload: payload);
  }

  static Future _notificationsDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channel name',
        importance: Importance.max,
        playSound: true,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: 1,
        attachments: [],
        //ne pas oublier de mettre une image medicale comme attachment
        subtitle: 'SOP',
        threadIdentifier: "HAH",
      ),
    );
  }

  static Future<void> testHealth() async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('checkHealth');
    final response = await callable.call();
    if (response.data != null) {
      showNotifications(
          title: 'test de Val', body: response.data, payload: 'voila');
    }
  }

  //ca c est pour envoyer des notifications a un utilisateur specifique
  static Future<void> sendNotification(
      {required message,
      required title,
      required Usertoken,
      required nombre_de_fois}) async {
    final HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('sendNotification');
    try {
      for (int i = 0; i < nombre_de_fois; i++) {
        final HttpsCallableResult result =
            await callable.call(<String, dynamic>{
          'title': title,
          'body': message,
          'token': Usertoken, // Remplace par le token de l'utilisateur
        });
        //a verifier***
        /* NotificationService.showNotifications(
            title: 'HAH', body: 'message Sent', payload: 'hah');*/
        print(result);
      }
    } catch (e) {
      print('Erreur lors de l\'envoi de la notification: $e');
    }
  }

  //TODO ON VA ENVOYER DES NOTIFICATIONS A TOUS LES UTILISATEURS

  static Future<void> sendNotificationAlluser(
      {required title, required body}) async {
    const String functionUrl =
        'https://us-central1-my-firebase-project.cloudfunctions.net/sendNotificationToAll';
    //TODO il faut remplacer le lien functionUrl par celui de notre fonction dans firebase cloud function
    try {
      final response = await http.post(
        Uri.parse(functionUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'title': title,
          'body': body,
        }),
      );

      if (response.statusCode == 200) {
        print('Notification envoyée: ${response.body}');
      } else {
        print('Erreur lors de l\'envoi de la notification: ${response.body}');
      }
    } catch (e) {
      print('Erreur lors de l\'envoi de la notification: $e');
    }
  }

  // n oublie pas tout modifier (en creant des document specifier pour chaque utilisateur)

  static Future<void> checkAndUpdateToken(
      {required bool ifAdminis,
      required String nomAdmin,
      required String idAdm}) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    User? user1 = FirebaseAuth.instance.currentUser;
    if (token != null) {
      // Récupérer le token stocké dans Firestore
      DocumentSnapshot tokenDoc = await FirebaseFirestore.instance
          .collection('idtelephone')
          .doc('clients')
          .collection('tokens')
          .doc(user1!
              .email) // Remplace 'user123' par l'ID de l'utilisateur actuel
          .get();
      if (tokenDoc.exists) {
        String storedToken = tokenDoc['token'];

        // Vérifier si le token a changé
        if (storedToken != token) {
          // Mettre à jour le token dans Firestore
          await FirebaseFirestore.instance
              .collection('idtelephone')
              .doc('clients')
              .collection('tokens')
              .doc(user1
                  .email) // Remplace 'user123' par l'ID de l'utilisateur actuel
              .update({'token': token});
          //pour la collection profil
          await FirebaseFirestore.instance
              .collection('usersglobal')
              .doc(user1
                  .email) // Remplace 'user123' par l'ID de l'utilisateur actuel
              .update({'token': token});
          //l'id de l'administrateur
          Future.delayed(Duration(seconds: 10));
          if (ifAdminis == true)
            await FirebaseFirestore.instance
                .collection('administrateurs')
                .doc("idDocument")
                .update({"id_$nomAdmin": idAdm});
          print("Token mis à jour !");
        } else {
          print("Le token est déjà à jour.");
        }
      } else {
        // Si le document n'existe pas, créer un nouveau document avec le token
        await FirebaseFirestore.instance
            .collection('idtelephone')
            .doc('clients')
            .collection('tokens')
            .doc(user1
                .email) // Remplace 'user123' par l'ID de l'utilisateur actuel
            .set({'token': token});
        //l'id de l'administrateur
        Future.delayed(Duration(seconds: 10));
        if (ifAdminis == true)
          await FirebaseFirestore.instance
              .collection('administrateurs')
              .doc("idDocument")
              .update({"id_$nomAdmin": idAdm});
        print("Token enregistré pour la première fois !");
      }
    }
  }
}
