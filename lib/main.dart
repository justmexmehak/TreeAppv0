import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      pageBuilder: (context, state) => const MaterialPage(child: MyPage())
    )
  ]
);

const baseUrl = "https://c3ec-39-39-65-18.ngrok-free.app/dj-rest-auth/";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        routeInformationProvider: _router.routeInformationProvider,
      // home: MyPage(),
      color: colorBg,
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 360,
          height: 800,
          decoration: BoxDecoration(
            border: Border.all(),
            image: const DecorationImage(
              image: AssetImage('assets/images/bg_leaf.png'),
              fit: BoxFit.cover,
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/leaf.png'),
              Text(
                'SIGN UP',
                style: headingStyle()
              ),
              const SizedBox(height: 60),
              const SignUpForm(),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle headingStyle() => const TextStyle(
    color: colorGreen,
    fontWeight: FontWeight.w700,
    fontSize: 25,
    fontFamily: 'roboto',
  );

   TextStyle labelStyle() => const TextStyle(
    color: colorGreen,
    fontWeight: FontWeight.w400,
    fontSize: 15,
    fontFamily: 'public sans',
  );
}

const colorGreen = Color.fromRGBO(19, 72, 62, 1);
const colorBg = Color.fromRGBO(231, 232, 227, 1);

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});


  @override
  SignUpFormState createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  String _inputName = '';
  String _inputEmail = '';
  String _inputPass1 = '';
  String _inputPass2 = '';

  final _formKey = GlobalKey<FormState>();
  
  @override 
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 80, child: Text('NAME', style: labelStyle())),
              const SizedBox(width: 20),
              SizedBox(
                width: 170,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter your name',
                  ),
                  validator: nameValidator,
                  onSaved: (value) {
                    _inputName = value!;
                  }
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 80, child: Text('EMAIL', style: labelStyle())),
              const SizedBox(width: 20),
              SizedBox(
                width: 170,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                  ),
                  validator: emailValidator,
                  onSaved: (value) {
                    _inputEmail = value!;
                  }
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 80, child: Text('PASSWORD', style: labelStyle())),
              const SizedBox(width: 20),
              SizedBox(
                width: 170,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter password',
                  ),
                  obscureText: true,
                  validator: pass1Validator,
                  onSaved: (value) {
                    _inputPass1 = value!;
                  }
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 80, child: Text('PASSWORD', style: labelStyle())),
              const SizedBox(width: 20),
              SizedBox(
                width: 170,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter password again',
                  ),
                  obscureText: true,
                  validator: pass2Validator,
                  onSaved: (value) {
                    _inputPass2 = value!;
                  }
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () async {
              if(_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                debugPrint('Name: $_inputName, Email: $_inputEmail, Password: $_inputPass1, Password2: $_inputPass2');
                var response = await http.post(Uri.parse("${baseUrl}registration/"), body: {
                  'username': _inputName,
                  'email': _inputEmail,
                  'password1': _inputPass1,
                  'password2': _inputPass2
                });
                if (response.statusCode == 400) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response.body, style: const TextStyle(color: Colors.red)), backgroundColor: Colors.red.shade100,)
                  );
                } else if (response.statusCode == 204) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Account Created. You can now Log In.', style: TextStyle(color: Colors.green.shade900),), backgroundColor: Colors.green.shade100,)
                  );
                }
                
              }
            },
            style: mainBtnStyle(),
            child: const Text('Submit'),
          )
        ],
      )
    );
  }

  TextStyle labelStyle() => const TextStyle(color: colorGreen, fontWeight: FontWeight.w400, fontFamily: 'public sans', fontSize: 15);

  String? nameValidator(value) {
            debugPrint("Validating..");
            if (value == null || value.isEmpty) {
              return 'Please Enter your name';
            }
            return null;
          }

  String? pass2Validator(value) {
            debugPrint("Validating..");
            if (value == null || value.isEmpty) {
              return 'Please Enter your password again';
            }
            if (value != _inputPass1) {
              return 'Passwords do not match';
            }
            return null;
          }

  String? pass1Validator(value) {
            debugPrint("Validating..");
            if (value == null || value.isEmpty) {
              return 'Please Enter your Password';
            }
            _inputPass1 = value;
            return null;
          }

  String? emailValidator(value) {
            debugPrint("Validating..");
            if (value == null || value.isEmpty) {
              return 'Please Enter your Email';
            }
            final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-z0-9.-]+\.[a-zA-z]{2,}$');
            if (!emailRegex.hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          }

  ButtonStyle mainBtnStyle() => ButtonStyle(
    fixedSize: MaterialStateProperty.all<Size>(const Size(177, 64)),
    backgroundColor: MaterialStateProperty.all<Color>(colorGreen),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)))
  );
}