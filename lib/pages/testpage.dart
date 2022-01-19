import "dart:developer";
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_webrtc/flutter_webrtc.dart';

class TestPage extends StatefulWidget {
  static String tag = 'loopback_sample';

  @override
  TestPageState createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  final mediaConstraints = <String, dynamic>{'audio': true, 'video': false};

  var configuration = <String, dynamic>{
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
    ],
    'sdpSemantics': 'unified-plan'
  };

  final offerSdpConstraints = <String, dynamic>{
    'mandatory': {
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': false,
    },
    'optional': [],
  };

  final loopbackConstraints = <String, dynamic>{
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': false},
    ],
  };

  MediaStream? _localStream;
  RTCPeerConnection? _peerConnection;

  @override
  void initState() {
    super.initState();
    this.connect();
  }

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
    _peerConnection?.addCandidate(candidate);
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

  void connect() async {
    if (_peerConnection != null) return;

    try {
      this._peerConnection =
          await createPeerConnection(configuration, loopbackConstraints);

      this._peerConnection!.onSignalingState = _onSignalingState;
      this._peerConnection!.onIceGatheringState = _onIceGatheringState;
      this._peerConnection!.onIceConnectionState = _onIceConnectionState;
      _peerConnection!.onConnectionState = _onPeerConnectionState;
      this._peerConnection!.onIceCandidate = _onCandidate;
      this._peerConnection!.onRenegotiationNeeded = _onRenegotiationNeeded;

      _localStream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);

      _peerConnection!.onTrack = _onTrack;
      _peerConnection!.onAddTrack = _onAddTrack;
      _peerConnection!.onRemoveTrack = _onRemoveTrack;
      _localStream!.getTracks().forEach((track) {
        _peerConnection!.addTrack(track, _localStream!);
      });

      var description = await _peerConnection!.createOffer(offerSdpConstraints);
      inspect(description);
      var sdp = description.sdp;
      print('sdp = $sdp');
      await _peerConnection!.setLocalDescription(description);
      //change for loopback.
      var sdp_answer = sdp?.replaceAll('setup:actpass', 'setup:active');
      var description_answer = RTCSessionDescription(sdp_answer!, 'answer');
      await _peerConnection!.setRemoteDescription(description_answer);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("hoge"));
  }
}
