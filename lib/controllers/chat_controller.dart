import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  var isLoading = false.obs;
  RxList messages = [].obs;
  var isTyping = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    messageController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    _loadMessages();
    _loadTypingStatus();
    messageController.addListener(_onMessageControllerChange);
  }

  void _loadMessages() {
    firestore
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .listen((data) {
      messages.value = data.docs;
    });
  }

  void _loadTypingStatus() {
    firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        isTyping.value = snapshot['isTyping'];
      }
    });
  }
  // void _loadTypingStatus() {
  //   firestore.collection('users').limit(1).get().then((snapshot) {
  //     if (snapshot.docs.isNotEmpty) {
  //       var firstUserDoc = snapshot.docs.first;
  //       firestore
  //           .collection('users')
  //           .doc(firstUserDoc.id)
  //           .snapshots()
  //           .listen((doc) {
  //         if (doc.exists) {
  //           isTyping.value = doc['isTyping'];
  //         }
  //       });
  //     }
  //   });
  // }

  // void _loadTypingStatus() {
  //   firestore
  //       .collection('users')
  //       .where(FieldPath.documentId, isNotEqualTo: auth.currentUser!.uid)
  //       .snapshots()
  //       .listen((snapshot) {
  //     bool anyUserTyping = false;
  //     for (var doc in snapshot.docs) {
  //       if (doc.exists && doc['isTyping'] == true) {
  //         anyUserTyping = true;
  //         break;
  //       }
  //     }
  //     isTyping.value = anyUserTyping;
  //   });
  // }

  void _onMessageControllerChange() {
    if (messageController.text.isEmpty) {
      updateTypingStatus(false);
    } else {
      updateTypingStatus(true);
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.isNotEmpty) {
      await firestore.collection('messages').add({
        'text': text,
        'sender': auth.currentUser!.email,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      updateTypingStatus(false);
      messageController.clear();
    }
  }

  void updateTypingStatus(bool typing) {
    firestore.collection('users').doc(auth.currentUser!.uid).set({
      'isTyping': typing,
    });
  }

  void changeLoading() {
    isLoading.value = !isLoading.value;
  }
}
