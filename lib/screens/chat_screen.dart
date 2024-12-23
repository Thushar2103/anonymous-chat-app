import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../services/encrypt.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  const ChatScreen({super.key, required this.roomId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;
  late final Stream<List<Map<String, dynamic>>> messageStream;
  late final ScrollController scrollController;

  final String senderId = const Uuid().v4();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    messageStream = supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', widget.roomId)
        .order('created_at');
  }

  Future<void> sendMessage(String message) async {
    final String encryptedMessage =
        EncryptionDecryption.encryptMessage(message);

    await supabase.from('messages').insert({
      'room_id': widget.roomId,
      'message': encryptedMessage,
      'sender_id': senderId,
    });
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Widget list() {
    return Container(
      decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
      child: Column(children: [
        if (!kIsWeb)
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              height: 30,
              child: Row(
                children: [
                  Expanded(child: SizedBox()),
                  ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.roomId));
                    },
                    label: Text('Id'),
                    icon: Icon(
                      Icons.copy_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: messageStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final messages = snapshot.data ?? [];

              if (messages.isEmpty) {
                return Center(
                  child: Text(
                    "No messages yet. Start the conversation!",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              // Scroll to the bottom after loading new messages
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (scrollController.hasClients) {
                  scrollToBottom();
                }
              });

              messages.sort((a, b) {
                // Compare the 'created_at' fields and sort in ascending order
                final timeA = DateTime.parse(a['created_at']);
                final timeB = DateTime.parse(b['created_at']);
                return timeA.compareTo(timeB);
              });

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMyMessage = message['sender_id'] == senderId;
                    String decryptedMessage =
                        EncryptionDecryption.decryptMessage(message['message']);
                    String date = DateFormat('MMM dd HH:mm:ss')
                        .format(DateTime.parse(message['created_at']));

                    return Align(
                      alignment: isMyMessage
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: isMyMessage
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            margin: EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isMyMessage
                                  ? Color(0xFFEFF3FF)
                                  : Color(0xFFEEEEEE),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                                bottomLeft: isMyMessage
                                    ? Radius.circular(30)
                                    : Radius.zero,
                                bottomRight: isMyMessage
                                    ? Radius.zero
                                    : Radius.circular(30),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: isMyMessage
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // message['message'],
                                  decryptedMessage,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamilyFallback: ['Noto Color Emoji'],
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  date,
                                  style: TextStyle(
                                      fontSize: 8,
                                      // fontWeight: FontWeight.w,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              isMyMessage ? 'You' : 'Anonymous',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF478E7E),
                  ),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: messageController,
                    maxLines: 8,
                    minLines: 1,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: 'Write Message',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none)),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              IconButton.filled(
                  iconSize: 33,
                  style: ButtonStyle(
                      shape: WidgetStatePropertyAll(ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))),
                  onPressed: () {
                    final message = messageController.text.trim();
                    if (message.isNotEmpty) {
                      sendMessage(message);
                      messageController.clear();
                    }
                  },
                  icon: Icon(Icons.send))
            ],
          ),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return list();
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text('Chat Room'),
            actions: [
              ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: widget.roomId));
                },
                label: Text('Copy ID'),
                icon: Icon(Icons.copy_rounded, color: Colors.white),
              ),
            ],
          ),
          body: list());
    }
  }
}
