import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infobip_voice_showcase/core/session.dart';
import 'package:infobip_voice_showcase/ui/pages/main_page/main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController _applicationIdController = TextEditingController();
  final TextEditingController _identityController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();

  bool loginInProgress = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _applicationIdController.dispose();
    _identityController.dispose();
    super.dispose();
  }

  void performLogin() async {
    if (loginInProgress) {
      return;
    }
    setState(() {
      loginInProgress = true;
    });
    if (_applicationIdController.text.isEmpty || _identityController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill the fields to login",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() {
        loginInProgress = false;
      });
      return;
    }
    final success = await Session.instance.performLoginForToken(
      applicationId: _applicationIdController.text,
      displayName: _displayNameController.text,
      identity: _identityController.text,
    );

    if (success) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const MainPage()));
    }

    setState(() {
      loginInProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Infobip WebRTC')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/webrtc.png",
                height: 150,
              ),
              // username password fields
              TextField(
                controller: _displayNameController,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                ),
              ),
              TextField(
                controller: _identityController,
                decoration: const InputDecoration(
                  labelText: 'Identity',
                ),
              ),
              TextField(
                controller: _applicationIdController,
                decoration: const InputDecoration(
                  labelText: 'applicationId',
                ),
              ),
              const SizedBox(height: 12),
              if (loginInProgress) const LinearProgressIndicator(value: null),
              MaterialButton(
                onPressed: performLogin,
                child: const Text("Login"),
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Theme.of(context).buttonTheme.colorScheme?.inversePrimary,
              )
            ],
          ),
        ),
      ),
    );
  }
}
