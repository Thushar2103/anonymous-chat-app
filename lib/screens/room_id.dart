import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../screens/chat_screen.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomId extends StatefulWidget {
  const RoomId({super.key});

  @override
  State<RoomId> createState() => _RoomIdState();
}

class _RoomIdState extends State<RoomId> {
  final FlipCardController _cardcontroller = FlipCardController();
  final TextEditingController roomIdController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> saveNewId(String id) async {
    // String newId = DateTime.now()
    //     .millisecondsSinceEpoch
    //     .toString(); // Generate a unique ID
    // await LocalStorageRepository.saveId(id);
    // loadIds(); // Reload the list of IDs after saving
  }

  Future<String> createRoom() async {
    final response =
        await supabase.from('chat_rooms').insert({}).select().single();
    final roomId = response['id'] as String;
    return roomId;
  }

  Widget createroom() {
    return Container(
      height: 200,
      width: 300,
      color: Color(0xFFEEEEEE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () async {
                final roomid = await createRoom();
                await saveNewId(roomid);

                if (kIsWeb) {
                  context.go('/chat/$roomid');
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(roomId: roomid)),
                  );
                }
              },
              child: Text('Create Room')),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () => _cardcontroller.toggleCard(),
              child: Text('Join Room'))
        ],
      ),
    );
  }

  Widget joinroom() {
    return Container(
      height: 200,
      width: 300,
      color: Color(0xFFEEEEEE),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: roomIdController,
              decoration: InputDecoration(
                  labelText: "Enter Room ID", border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final roomId = roomIdController.text.trim();
                await saveNewId(roomId);
                if (roomId.isNotEmpty) {
                  if (kIsWeb) {
                    context.go('/chat/$roomId');
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(roomId: roomId)),
                    );
                  }
                }
              },
              child: Text("Join Room"),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () => _cardcontroller.toggleCard(),
                child: Text('Create Room'))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: FlipCard(
                flipOnTouch: false,
                speed: 500,
                front: createroom(),
                back: joinroom(),
                controller: _cardcontroller,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
