import 'package:flutter/material.dart';

class NameEnter extends StatelessWidget {
  NameEnter({Key? key, required this.onNext}) : super(key: key);

  final onNext;
  final _formKey = GlobalKey<FormState>();
  String? _name;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter your Name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter some text';
                    return null;
                  },
                  onChanged: (value) {
                    _name = value;
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        onNext(_name);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text("Next"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
