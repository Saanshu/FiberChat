import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/subtext.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final email = TextEditingController();
  final username = TextEditingController();
  var password = TextEditingController();
  var confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
          _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
    SizedBox(height: deviceSize.height * 0.1,),
    Image.asset(
      'assets/images/newlogo.jpg',
      width: 80,
      height: 80,
    ),
    const SizedBox(
      height: 5,
    ),
    Text('NEWGEN', style: TextStyle(fontSize: 30, color: Colors.green.shade600),),
    const SizedBox(height: 50,),
    Container(
      height: !_isLogin ? 380 : 300,
      width: deviceSize.width * 0.85,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(5)),
      child: Card(
        elevation: 0,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: email,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value.isEmpty ||
                          !value.contains('@') ||
                          !value.contains('.')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                    ),
                    onChanged: (value) {
                      _userEmail = value.trim();
                    },
                    onEditingComplete: () =>
                        FocusScope.of(context).nextFocus(),
                  ),
                  if (!_isLogin)
                    TextFormField(
                        controller: username,
                        autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                        textCapitalization: TextCapitalization.sentences,
                        key: const ValueKey('username'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return 'Please enter at least 4 characters';
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(labelText: 'Username'),
                        onSaved: (value) {
                          _userName = value.trim();
                        },
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus()),
                  TextFormField(
                      controller: password,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: const ValueKey('password'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 6) {
                          return 'Password must be at least 6 characters long.';
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onSaved: (value) {
                        _userPassword = value.trim();
                      },
                      onEditingComplete: () {
                        !_isLogin
                            ? FocusScope.of(context).nextFocus()
                            : FocusScope.of(context).unfocus();
                      }),
                  if (!_isLogin)
                    TextFormField(
                        controller: confirmPassword,
                        autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                        key: const ValueKey('confirmPassword'),
                        validator: (value) {
                          if (confirmPassword.text != _userPassword) {
                            return 'Passwords dont match.';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password'),
                        obscureText: true,
                        onChanged: (value) {
                          _userPassword = value.trim();
                        },
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus()),
                  const SizedBox(height: 12),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading && _isLogin)
                    TextButton(
                      child: const Text('Forgot password?',
                          style: TextStyle(fontSize: 17)),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/password');
                      },
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      child: Text(
                        _isLogin
                            ? 'Create new account'
                            : 'I already have an account',
                        style: const TextStyle(fontSize: 17),
                      ),
                      onPressed: () {
                        email.clear();
                        password.clear();
                        username.clear();
                        confirmPassword.clear();
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    SizedBox(height: _isLogin?deviceSize.height * 0.31:deviceSize.height * 0.21,),
    const SubText(),
      ]),
    );
  }
}
