import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CreateVoiceChatForm extends StatefulWidget {
  const CreateVoiceChatForm({Key? key}) : super(key: key);

  @override
  _CreateVoiceChatFormState createState() {
    return _CreateVoiceChatFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class _CreateVoiceChatFormState extends State<CreateVoiceChatForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("チャット作成")),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text("タイトル"),
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextButton(
                    onPressed: () {},
                    child: Text("作成"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
