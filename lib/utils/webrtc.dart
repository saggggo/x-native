import "dart:developer";
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import "../api/firestore.dart";

final _firestore = FirebaseFirestore.instance;

class SignalingMessage {}

class WebrtcClient {
  static const _mediaConstraints = <String, dynamic>{
    'audio': true,
    'video': false
  };

  static const _configuration = <String, dynamic>{
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
    ],
    'sdpSemantics': 'unified-plan'
  };

  static const _offerSdpConstraints = <String, dynamic>{
    'mandatory': {
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': false,
    },
    'optional': [],
  };

  static const _loopbackConstraints = <String, dynamic>{
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': false},
    ],
  };

  static WebrtcClient? _singleton;
  final String userId;
  VoiceChat? voiceChat;
  MediaStream? _localStream;
  String? geohash;
  String? chatId;
  Map<String, RTCPeerConnection> _peerConnections = {};
  // DocumentReference? _voiceChatRef;

  factory WebrtcClient(String userId) {
    if (_singleton != null) {
      return _singleton!;
    } else {
      _singleton = WebrtcClient._internal(userId);
      return _singleton!;
    }
  }

  WebrtcClient._internal(this.userId);

  void enter(String geohash, String chatId) async {
    print(geohash);
    this.geohash = geohash;
    this.chatId = chatId;

    _firestore
        .collection("spots")
        .doc(geohash)
        .collection("voiceChat")
        .doc(chatId)
        .snapshots()
        .listen((doc) {
      var data = doc.data();
      if (data != null) {
        this.voiceChat = VoiceChat.from(data);
      }
    });

    _firestore
        .collection("spots")
        .doc(geohash)
        .collection("voiceChat")
        .doc(chatId)
        .collection(userId)
        .snapshots()
        .listen((event) {
      event.docs.forEach((doc) {
        var data = doc.data();
        print(data);
        var msg = data as SignalingMessage;
      });
    });

    await VoiceChat.update(geohash, chatId, {
      "members": FieldValue.arrayUnion([this.userId])
    });

    if (voiceChat != null) {
      voiceChat!.members.forEach((memberId) {
        if (memberId != userId) {
          this._offer(memberId);
        }
      });
    }
  }

  void _offer(String peerId) async {
    if (_peerConnections.containsKey(peerId)) {
      return;
    } else {
      if (_localStream == null) {
        _localStream =
            await navigator.mediaDevices.getUserMedia(_mediaConstraints);
      }

      var pc = await createPeerConnection(_configuration, _loopbackConstraints);
      pc.onSignalingState = _onSignalingState;
      pc.onIceGatheringState = _onIceGatheringState;
      pc.onIceConnectionState = _onIceConnectionState;
      pc.onConnectionState = _onPeerConnectionState;
      pc.onIceCandidate = _onCandidate;
      pc.onRenegotiationNeeded = _onRenegotiationNeeded;
      pc.onTrack = _onTrack;
      pc.onAddTrack = _onAddTrack;
      pc.onRemoveTrack = _onRemoveTrack;
      _localStream!.getTracks().forEach((track) {
        pc.addTrack(track, _localStream!);
      });
      var description = await pc.createOffer(_offerSdpConstraints);
      var sdp = description.sdp;
      await pc.setLocalDescription(description);
      _firestore
          .collection("spots")
          .doc(geohash)
          .collection("voiceChat")
          .doc(chatId)
          .collection(peerId)
          .add({"from": this.userId, "sdp": sdp, "createdAt": now()});

      _peerConnections.putIfAbsent(peerId, () => pc);
    }
  }

  void close() {}

  void _onSignalingState(RTCSignalingState state) {
    print("SignalingState: " + state.toString());
  }

  void _onIceGatheringState(RTCIceGatheringState state) {
    print("IceGatheringState: " + state.toString());
  }

  void _onIceConnectionState(RTCIceConnectionState state) {
    print("IceConnectionState: " + state.toString());
  }

  void _onPeerConnectionState(RTCPeerConnectionState state) {
    print("PeerConnectionState: " + state.toString());
  }

  void _onAddStream(MediaStream stream) {
    print('New stream: ' + stream.id);
  }

  void _onRemoveStream(MediaStream stream) {
    print("stream removed");
  }

  void _onCandidate(RTCIceCandidate candidate) {
    print('onCandidate: ${candidate.candidate}');
    // _peerConnection?.addCandidate(candidate);
  }

  void _onTrack(RTCTrackEvent event) {
    print('onTrack');
  }

  void _onAddTrack(MediaStream stream, MediaStreamTrack track) {
    print("track added");
  }

  void _onRemoveTrack(MediaStream stream, MediaStreamTrack track) {
    print("track removed");
  }

  void _onRenegotiationNeeded() {
    print('RenegotiationNeeded');
  }
}
