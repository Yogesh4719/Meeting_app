import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:zoom_clone/resources/auth_methods.dart';
import 'package:zoom_clone/resources/firestore_methods.dart';

class JitsiMeetMethods {
  final AuthMethods _authMethods = AuthMethods();
  final FirestoreMethods _firestoreMethods = FirestoreMethods();

  final JitsiMeet _jitsiMeet = JitsiMeet();

  Future<void> createMeeting({
    required String roomName,
    required bool isAudioMuted,
    required bool isVideoMuted,
    String username = "",
  }) async {
    try {
      String name = username.isEmpty
          ? (_authMethods.user?.displayName ?? "Guest")
          : username;

      var options = JitsiMeetConferenceOptions(
        room: roomName,
        serverURL: "https://meet.ffmuc.net", // ✅ FIXED
        userInfo: JitsiMeetUserInfo(
          displayName: name,
          email: _authMethods.user?.email,
          avatar: _authMethods.user?.photoURL,
        ),
        configOverrides: {
          "startWithAudioMuted": isAudioMuted,
          "startWithVideoMuted": isVideoMuted,
        },
        featureFlags: {
          "welcomepage.enabled": false,
        },
      );

      _firestoreMethods.addToMeetingHistory(roomName);

      await _jitsiMeet.join(options);
    } catch (e) {
      print("Error joining meeting: $e");
    }
  }
}