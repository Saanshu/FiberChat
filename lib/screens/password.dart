import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/subtext.dart';

class Password extends StatefulWidget {
  const Password({Key key}) : super(key: key);

  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final _auth = FirebaseAuth.instance;
  final _formKey2 = GlobalKey<FormState>();
  String _userEmail;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Reset Password'),),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Enter email to reset your password', style: TextStyle(fontSize: 20),),
            ),
            const SizedBox(height: 7,),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Check your email for the password reset link.', style: TextStyle(fontSize: 15, color: Color.fromARGB(255,119,136,153)),),
            ),
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Form(
                  key: _formKey2,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          key: const ValueKey('email'),
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email address',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _userEmail = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () async{
                              await _auth.sendPasswordResetEmail(
                                  email: _userEmail);
                              Navigator.of(context)
                                  .pushReplacementNamed('/auth');
                            },
                            child: const Text(
                              'Send Email',
                              style: TextStyle(fontSize: 18),
                            ))
                      ]),
                ),
              ),
            ),
            SizedBox(height: deviceSize.height * 0.59,),
            const SubText(),
              ],
            ),
          ),
        ));
  }
}
