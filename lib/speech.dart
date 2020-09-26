import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';
import 'consts.dart';

class SpeechScreen extends StatefulWidget {
  final String name, to;
  SpeechScreen({this.name, this.to});
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen>
    with AutomaticKeepAliveClientMixin {
  GoogleTranslator translator = GoogleTranslator();
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;
  String normalText = '';
  String from, to;
  @override
  void initState() {
    super.initState();
    to = widget.to;
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Center(
            child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context)),
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.radio),
          onPressed: () => settingModalBottomSheet(context, normalText),
        ),
        title: Text(_isListening
            ? 'Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'
            : 'Start Recording Now ${widget.name}'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: EdgeInsets.all(40),
          child: Text(
            _text,
            style: TextStyle(
              fontSize: 32.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: _result);
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _result(SpeechRecognitionResult val) async {
    final input = val.recognizedWords;
    var userWords = await translator.translate(input, from: 'en', to: to);
    setState(() {
      _text = userWords.text;
      if (val.hasConfidenceRating && val.confidence > 0) {
        _confidence = val.confidence;
      }
    });
    normalText = val.recognizedWords;
  }

  @override
  bool get wantKeepAlive => true;
}
