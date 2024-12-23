// import 'package:shared_preferences/shared_preferences.dart';

// class LocalStorageRepository {
//   static const String chatIdsKey = 'chat_ids';
//   static const String timestampKey = 'timestamp';

//   // Save a single ID with the current timestamp if it does not already exist
//   static Future<void> saveId(String id) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();

//       // Get the current list of IDs, or initialize an empty list
//       List<String> existingIds = prefs.getStringList(chatIdsKey) ?? [];

//       // Check if the ID already exists in the list
//       if (!existingIds.contains(id)) {
//         // Save the new ID to the list
//         existingIds.add(id);
//         await prefs.setStringList(
//             chatIdsKey, existingIds); // Save the updated list

//         // Save the current timestamp when the ID is saved
//         await prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
//       }
//     } catch (e) {
//       print('Error saving ID: $e');
//     }
//   }

//   // Get all saved IDs and check if they are expired (older than 12 hours)
//   static Future<List<String>> getIds() async {
//     final prefs = await SharedPreferences.getInstance();
//     final timestamp = prefs.getInt(timestampKey);

//     // Check if 12 hours have passed since the timestamp
//     if (timestamp != null &&
//         DateTime.now().millisecondsSinceEpoch - timestamp >
//             12 * 60 * 60 * 1000) {
//       // If 12 hours have passed, clear the saved IDs and timestamp
//       await clearData();
//       return [];
//     }

//     return prefs.getStringList(chatIdsKey) ?? []; // Return the stored IDs
//   }

//   // Clear all saved IDs and the timestamp
//   static Future<void> clearData() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove(chatIdsKey); // Remove all saved IDs
//       await prefs.remove(timestampKey); // Remove the timestamp
//     } catch (e) {
//       print('Error clearing data: $e');
//     }
//   }
// }
