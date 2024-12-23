import '../components/windows_button.dart';
import '../screens/chat_screen.dart';
import '../screens/room_id.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _selectedRoomId;

  @override
  void initState() {
    super.initState();
    // loadIds(); // Load IDs when the app starts
  }

  // Future<void> loadIds() async {
  //   // List<String> ids = await LocalStorageRepository.getIds();
  //   setState(() {
  //     _storedIds = ids;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30),
        child: MoveWindow(
          child: AppBar(
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: MouseRegion(
                child: GestureDetector(
                  onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ),
                    (route) => false,
                  ),
                  child: Text(
                    'மரை',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            backgroundColor: Color(0xFFEEEEEE),
            toolbarHeight: 30,
            scrolledUnderElevation: 0,
            elevation: 0,
            actions: [
              const WindowsButton(), // Custom window buttons
            ],
          ),
        ),
      ),
      body: Row(
        children: [
          Container(
            width: 40,
            height: double.maxFinite,
            color: Color(0xFFEEEEEE),
            // child: ListView.builder(
            //   itemCount: _storedIds.length,
            //   itemBuilder: (context, index) {
            //     String roomId = _storedIds[index];
            //     return Padding(
            //       padding: const EdgeInsets.all(3.0),
            //       child: ElevatedButton(
            //         onPressed: () {
            //           setState(() {
            //             _selectedRoomId = roomId; // Update the selected roomId
            //           });
            //           Navigator.pushReplacement(
            //             context,
            //             MaterialPageRoute(
            //               builder: (_) => Home(),
            //             ),
            //           );
            //         },
            //         child: Text(
            //           (index + 1).toString(),
            //           style: TextStyle(fontSize: 10),
            //         ),
            //       ),
            //     );
            //   },
            // ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0, bottom: 8, top: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _selectedRoomId == null
                    ? Navigator(
                        initialRoute: '/roomid',
                        onGenerateRoute: (settings) {
                          if (settings.name == '/roomid') {
                            return MaterialPageRoute(builder: (_) => RoomId());
                          } else {
                            return MaterialPageRoute(
                                builder: (_) => ChatScreen(roomId: ''));
                          }
                        },
                      )
                    : ChatScreen(roomId: _selectedRoomId!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
