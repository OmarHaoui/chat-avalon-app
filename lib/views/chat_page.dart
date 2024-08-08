import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_avalon2/utils/formatters/formatter.dart';
import '../controllers/chat_controller.dart';
import '../utils/constants/colors.dart';
import 'animations/dot_animation.dart';
import 'login_page.dart';

class ChatScreen extends StatelessWidget {
  final ChatController chatController = Get.find<ChatController>();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatty.',
            style: TextStyle(color: TColors.primary, fontSize: 30)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await chatController.auth.signOut();
              Get.offAll(LoginScreen());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (scrollController.hasClients) {
                  scrollController
                      .jumpTo(scrollController.position.maxScrollExtent);
                }
              });

              return ListView.builder(
                controller: scrollController,
                itemCount: chatController.messages.length +
                    1, // Adding one for the typing indicator
                itemBuilder: (context, index) {
                  if (index == chatController.messages.length) {
                    return Obx(() => chatController.isTyping.value
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              decoration: BoxDecoration(
                                color: TColors.grey,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: TypingIndicator(),
                            ),
                          )
                        : Container());
                  }

                  var message = chatController.messages[index];
                  var isMine = message['sender'] ==
                      chatController.auth.currentUser!.email;

                  return Align(
                    alignment:
                        isMine ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: isMine ? TColors.primary : TColors.grey,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message['text'],
                            style: TextStyle(
                              color: isMine ? TColors.textWhite : TColors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            TFormatter.formatTimestampMessengerStyle(
                              message['timestamp'],
                            ),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatController.messageController,
                    decoration:
                        const InputDecoration(labelText: 'Send a message...'),
                    onChanged: (text) {
                      chatController.updateTypingStatus(text.isNotEmpty);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    chatController.sendMessage(
                        chatController.messageController.value.text);
                    chatController.messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
