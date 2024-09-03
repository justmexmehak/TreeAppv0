import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      pageBuilder: (context, state) => const MaterialPage(child: HomePage())
    ),
    GoRoute(
      name: 'signup',
      path: '/signup',
      pageBuilder: (context, state) => const MaterialPage(child: MyPage())
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      pageBuilder: (context, state) => const MaterialPage(child: LogInPage())
    ),
    GoRoute(
      name: 'profile',
      path: '/profile',
      pageBuilder: (context, state) => const MaterialPage(child: ProfilePage())
    ),
    GoRoute(
      name: 'edit-profile',
      path: '/edit-profile',
      pageBuilder: (context, state) => const MaterialPage(child: EditProfilePage())
    ),
    GoRoute(
      name: 'verify-email',
      path: '/verify-email/:email',
      pageBuilder: (context, state) {
        final String email = state.pathParameters['email']!;
        return MaterialPage(child: VerifyEmailPage(email: email));
      }
    ),
  ]
);

// const baseUrl = "https://c647-39-39-65-18.ngrok-free.app/dj-rest-auth/";
const baseUrl = "http://127.0.0.1:8000";
// const baseUrl = "https://mehaknauman.pythonanywhere.com";

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


// ---------------------------------------- HOME PAGE --------------------------------------------------------------

class HomePage extends StatelessWidget {
  const HomePage({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          // height: 800,
          decoration: const BoxDecoration(
            // border: Border.all(),
            image: DecorationImage(
              image: AssetImage('assets/images/bg_leaf.png'),
              fit: BoxFit.cover,
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/leaf.png'),
              Text(
                'WELCOME',
                style: headingStyle()
              ),
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: () {
                  debugPrint('Log in button Pressed');
                  GoRouter.of(context).pushNamed('login');
                },
                style: mainBtnStyle(),
                child: const Text('LOG IN'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).pushNamed('signup');
                },
                style: mainBtnStyle(),
                child: const Text('SIGN UP'),
              ),
            ],
          ),
        ),
      )
    );
  }
}

// ------------------------------------------------ SIGN UP PAGE ------------------------------------------------------

class MyPage extends StatelessWidget {
  const MyPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(backgroundColor: colorBg, elevation: 0,),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            // width: 360,
            // height: 800,
            decoration: const BoxDecoration(
              // border: Border.all(),
              image: DecorationImage(
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
      ),
    );
  }
}


// --------------------------------------------- SIGN UP FORM ---------------------------------------------------


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
              SizedBox(width: 80, child: Text('USERNAME', style: labelStyle())),
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
                try {
                   var response = await http.post(Uri.parse("$baseUrl/dj-rest-auth/registration/"), body: {
                    'username': _inputName,
                    'email': _inputEmail,
                    'password1': _inputPass1,
                    'password2': _inputPass2
                  });
                  if (response.statusCode == 400) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response.body, style: const TextStyle(color: Colors.red)), backgroundColor: Colors.red.shade100,)
                    );
                  } else if (response.statusCode == 201) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Verification Email Sent', style: TextStyle(color: Colors.green.shade900),), backgroundColor: Colors.green.shade100,)
                    );
                    GoRouter.of(context).pushNamed('verify-email', pathParameters: {'email': _inputEmail});
                  } else if (response.statusCode == 204) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Account Created. You can now Log In.', style: TextStyle(color: Colors.green.shade900),), backgroundColor: Colors.green.shade100,)
                    );
                  }
                } catch(e) {
                  debugPrint("Exception: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Unable to connect to server',)),
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
  
}

// ------------------------------------------------ LOG IN PAGE ------------------------------------------------------

class LogInPage extends StatelessWidget {
  const LogInPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(backgroundColor: colorBg, elevation: 0,),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            // width: 360,
            // height: 800,
            decoration: const BoxDecoration(
              // border: Border.all(),
              image: DecorationImage(
                image: AssetImage('assets/images/bg_leaf.png'),
                fit: BoxFit.cover,
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/leaf.png'),
                Text(
                  'LOG IN',
                  style: headingStyle()
                ),
                const SizedBox(height: 60),
                const LogInForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// --------------------------------------------- lOG IN FORM ---------------------------------------------------


class LogInForm extends StatefulWidget {
  const LogInForm({super.key});

  @override
  LogInFormState createState() => LogInFormState();
}

class LogInFormState extends State<LogInForm> {
  String _inputName = '';
  String _inputPass = '';

  final _loginformKey = GlobalKey<FormState>();
  
  @override 
  Widget build(BuildContext context) {
    return Form(
      key: _loginformKey,
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
              SizedBox(width: 80, child: Text('PASSWORD', style: labelStyle())),
              const SizedBox(width: 20),
              SizedBox(
                width: 170,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter password',
                  ),
                  obscureText: true,
                  validator: passValidator,
                  onSaved: (value) {
                    _inputPass = value!;
                  }
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () async {
              if(_loginformKey.currentState!.validate()) {
                _loginformKey.currentState!.save();
                debugPrint('Name: $_inputName, Password: $_inputPass');
                try {
                  var response = await http.post(Uri.parse("$baseUrl/dj-rest-auth/login/"), body: {
                  'username': _inputName,
                  'password': _inputPass,
                });
                if (response.statusCode == 400) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response.body, style: const TextStyle(color: Colors.red)), backgroundColor: Colors.red.shade100,)
                  );
                } else if (response.statusCode == 200) {
                  print("Logging in ${response.body}");
                  Map<String, dynamic> jsonToken = jsonDecode(response.body);
                  String token = jsonToken['key'];
                  debugPrint(token);
                  storeToken(token);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logged In.', style: TextStyle(color: Colors.green.shade900),), backgroundColor: Colors.green.shade100,)
                  );
                  GoRouter.of(context).pushNamed('profile');
                }
                } catch(e) {
                  debugPrint("Exception: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Unable to connect to server',)),
                  );
                }
              }
            },
            style: mainBtnStyle(),
            child: const Text('LOGIN'),
          )
        ],
      )
    );
  }

  String? nameValidator(value) {
            debugPrint("Validating..");
            if (value == null || value.isEmpty) {
              return 'Please Enter your name';
            }
            return null;
          }

  String? passValidator(value) {
            debugPrint("Validating..");
            if (value == null || value.isEmpty) {
              return 'Please Enter your Password';
            }
            _inputPass = value;
            return null;
  }  
}

// --------------------------------------------- PROFILE PAGE -------------------------------------------------------------

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _text = '';
  bool _isLoading = true;
  bool _hasError = false;

   @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      String? result = await getToken();
      debugPrint('Fetched Token: $result');
      debugPrint('{"Authorization": "TOKEN $result"}');
      var response = await http.get(Uri.parse("$baseUrl/dj-rest-auth/user/"), headers: {
        'Authorization': 'TOKEN $result',
        'Accept': 'application/json'
      });
      // var response = await http.get(Uri.parse("${baseUrl}test_flutter/"));

      print(response.statusCode);
      print(response.body);
      print(response.headers);

      if (response.statusCode == 200) {
        setState(() {
          _text = response.body;
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
          debugPrint(response.body);
        });
      }
    } catch(e) {
      setState(() {
          _hasError = true;
          _isLoading = false;
          debugPrint('Exception while fetching data $e');
        });
    } 
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator())
      );
    }
    else if (_hasError) {
      return const Scaffold(
        body: Center(child: Text('Failed to load Profile'))
      );
    }
    else {
      return Scaffold(
      appBar: AppBar(backgroundColor: colorBg, elevation: 0,),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Menu')),
            ListTile(
              title: const Text('LogOut'),
              onTap: () async {
                try {
                  String? result = await getToken();
                  var response = await http.post(Uri.parse("$baseUrl/dj-rest-auth/logout/"), headers: {
                    'Authorization': 'TOKEN $result',
                  });
                  if (response.statusCode == 200) {
                    removeToken();
                    String? result2 = await getToken();
                    debugPrint('Proving log out.. $result2');

                    print("Logged out ${response.body}");
                    GoRouter.of(context).pushNamed('home');
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error logging out',)),
                    );
                    print("Log out error ${response.body}");
                  }
                } catch(e) {
                  debugPrint("Exception: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Unable to connect to server',)),
                  );
                }
              }
            ),
            ListTile(
              title: const Text('Edit Profile'),
              onTap: () {
                GoRouter.of(context).pushNamed('edit-profile');
              }
            ),
          ]
        ),
      ),
      body: Center(
        child: Container(
          // width: 360,
          // height: 800,
          decoration: const BoxDecoration(
           // border: Border.all(),
            image: DecorationImage(
              image: AssetImage('assets/images/bg_leaf.png'),
              fit: BoxFit.cover,
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/leaf.png'),
              Text(
                'PROFILE',
                style: headingStyle()
              ),
              const SizedBox(height: 100),
              Text(_text, maxLines: 7),
            ],
          ),
        ),
      ),
    );
    }
  }
}



// ------------------------------------------------ EDIT PROFILE PAGE ------------------------------------------------------

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({
    super.key,
  });

  Future<void> uploadImage(String urlInsertImage, int productId) async {
    // Pick an image
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print('Received File');
      File file = File(pickedFile.path);
      print('File');
      print('Picked File Path: ${pickedFile.path}');

      try {
        var file = File(pickedFile.path);
        var bytes = await file.readAsBytes();
        print('File read successfully. Size: ${bytes.length}');
      } catch (e) {
        print('Error reading file: $e');
      }

      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(urlInsertImage));
      request.fields['ProductId'] = productId.toString();
      print(request);

      request.files.add(await http.MultipartFile.fromPath('picture', file.path));

      print('Sending http request');
      // Send the request
      var response = await request.send();

      // Handle the response
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Failed to upload image');
      }
    } else {
      print('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(backgroundColor: colorBg, elevation: 0,),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            // width: 360,
            // height: 800,
            decoration: const BoxDecoration(
              // border: Border.all(),
              image: DecorationImage(
                image: AssetImage('assets/images/bg_leaf.png'),
                fit: BoxFit.cover,
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset('assets/images/leaf.png'),
                // Text(
                //   'SIGN UP',
                //   style: headingStyle()
                // ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () {
                    uploadImage(
                        'localhost:8000/api/upload',
                        123);
                  },
                  child: const Text('Upload Image'),
                )
                // const EditProfileForm(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}








// --------------------------------------------- EDIT PROFILE FORM ---------------------------------------------------


// class EditProfileForm extends StatefulWidget {
//   const EditProfileForm({super.key});

//   @override
//   EditProfileFormState createState() => EditProfileFormState();
// }

// class EditProfileFormState extends State<EditProfileForm> {
//   String _inputFirstName = '';
//   String _inputLastName = '';
//   String _inputCountry = '';
//   String _inputState = '';


//   final _formKey = GlobalKey<FormState>();
  
//   @override 
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(width: 80, child: Text('USERNAME', style: labelStyle())),
//               const SizedBox(width: 20),
//               SizedBox(
//                 width: 170,
//                 child: TextFormField(
//                   decoration: const InputDecoration(
//                     hintText: 'Enter your name',
//                   ),
//                   validator: nameValidator,
//                   onSaved: (value) {
//                     _inputName = value!;
//                   }
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(width: 80, child: Text('EMAIL', style: labelStyle())),
//               const SizedBox(width: 20),
//               SizedBox(
//                 width: 170,
//                 child: TextFormField(
//                   decoration: const InputDecoration(
//                     hintText: 'Enter your email',
//                   ),
//                   validator: emailValidator,
//                   onSaved: (value) {
//                     _inputEmail = value!;
//                   }
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(width: 80, child: Text('PASSWORD', style: labelStyle())),
//               const SizedBox(width: 20),
//               SizedBox(
//                 width: 170,
//                 child: TextFormField(
//                   decoration: const InputDecoration(
//                     hintText: 'Enter password',
//                   ),
//                   obscureText: true,
//                   validator: pass1Validator,
//                   onSaved: (value) {
//                     _inputPass1 = value!;
//                   }
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(width: 80, child: Text('PASSWORD', style: labelStyle())),
//               const SizedBox(width: 20),
//               SizedBox(
//                 width: 170,
//                 child: TextFormField(
//                   decoration: const InputDecoration(
//                     hintText: 'Enter password again',
//                   ),
//                   obscureText: true,
//                   validator: pass2Validator,
//                   onSaved: (value) {
//                     _inputPass2 = value!;
//                   }
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 40),
//           ElevatedButton(
//             onPressed: () async {
//               if(_formKey.currentState!.validate()) {
//                 _formKey.currentState!.save();
//                 debugPrint('Name: $_inputName, Email: $_inputEmail, Password: $_inputPass1, Password2: $_inputPass2');
//                 try {
//                    var response = await http.post(Uri.parse("${baseUrl}/dj-rest-auth/registration/"), body: {
//                     'username': _inputName,
//                     'email': _inputEmail,
//                     'password1': _inputPass1,
//                     'password2': _inputPass2
//                   });
//                   if (response.statusCode == 400) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(response.body, style: const TextStyle(color: Colors.red)), backgroundColor: Colors.red.shade100,)
//                     );
//                   } else if (response.statusCode == 204) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Account Created. You can now Log In.', style: TextStyle(color: Colors.green.shade900),), backgroundColor: Colors.green.shade100,)
//                     );
//                   }
//                 } catch(e) {
//                   debugPrint("Exception: $e");
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Unable to connect to server',)),
//                   );
//                 }
//               }
//             },
//             style: mainBtnStyle(),
//             child: const Text('Submit'),
//           )
//         ],
//       )
//     );
//   }

//   TextStyle labelStyle() => const TextStyle(color: colorGreen, fontWeight: FontWeight.w400, fontFamily: 'public sans', fontSize: 15);

//   String? nameValidator(value) {
//             debugPrint("Validating..");
//             if (value == null || value.isEmpty) {
//               return 'Please Enter your name';
//             }
//             return null;
//           }

//   String? pass2Validator(value) {
//             debugPrint("Validating..");
//             if (value == null || value.isEmpty) {
//               return 'Please Enter your password again';
//             }
//             if (value != _inputPass1) {
//               return 'Passwords do not match';
//             }
//             return null;
//           }

//   String? pass1Validator(value) {
//             debugPrint("Validating..");
//             if (value == null || value.isEmpty) {
//               return 'Please Enter your Password';
//             }
//             _inputPass1 = value;
//             return null;
//           }

//   String? emailValidator(value) {
//             debugPrint("Validating..");
//             if (value == null || value.isEmpty) {
//               return 'Please Enter your Email';
//             }
//             final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-z0-9.-]+\.[a-zA-z]{2,}$');
//             if (!emailRegex.hasMatch(value)) {
//               return 'Please enter a valid email address';
//             }
//             return null;
//           }
  
// }

// ------------------------------------------------ Verify Email PAGE ------------------------------------------------------

class VerifyEmailPage extends StatelessWidget {
  final String email;

  const VerifyEmailPage({
    super.key, 
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(backgroundColor: colorBg, elevation: 0,),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            // width: 360,
            // height: 800,
            decoration: const BoxDecoration(
              // border: Border.all(),
              image: DecorationImage(
                image: AssetImage('assets/images/bg_leaf.png'),
                fit: BoxFit.cover,
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/leaf.png'),
                Text(
                  'VERIFY EMAIL',
                  style: headingStyle()
                ),
                const SizedBox(height: 60),
                const VerifyEmailForm(),
                TextButton(onPressed: () async {
                  try {
                    var response = await http.post(Uri.parse("$baseUrl/dj-rest-auth/registration/resend-email/"), body: {
                    'email': email,
                  });
                  if (response.statusCode == 400) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response.body, style: const TextStyle(color: Colors.red)), backgroundColor: Colors.red.shade100,)
                    );
                  } else if (response.statusCode == 200) {
                    print("Verified ${response.body}");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Email Resent', style: TextStyle(color: Colors.green.shade900),), backgroundColor: Colors.green.shade100,)
                    );
                  }
                  } catch(e) {
                    debugPrint("Exception: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Unable to connect to server',)),
                    );
                  }
                }, child: const Text('Resend Email'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// --------------------------------------------- VERIFY EMAIL FORM ---------------------------------------------------


class VerifyEmailForm extends StatefulWidget {
  const VerifyEmailForm({super.key});

  @override
  VerifyEmailFormState createState() => VerifyEmailFormState();
}

class VerifyEmailFormState extends State<VerifyEmailForm> {
  String _inputCode = '';

  final _verifyEmailFormKey = GlobalKey<FormState>();
  
  @override 
  Widget build(BuildContext context) {
    return Form(
      key: _verifyEmailFormKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 80, child: Text('CODE', style: labelStyle())),
              const SizedBox(width: 20),
              SizedBox(
                width: 170,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter code',
                  ),
                  validator: codeValidator,
                  onSaved: (value) {
                    _inputCode = value!;
                  }
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () async {
              if(_verifyEmailFormKey.currentState!.validate()) {
                _verifyEmailFormKey.currentState!.save();
                debugPrint('Code: $_inputCode');
                try {
                  var response = await http.post(Uri.parse("$baseUrl/dj-rest-auth/registration/verify-email/"), body: {
                  'key': _inputCode,
                });
                if (response.statusCode == 400) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response.body, style: const TextStyle(color: Colors.red)), backgroundColor: Colors.red.shade100,)
                  );
                } else if (response.statusCode == 200) {
                  print("Verified ${response.body}");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('EmailVerified', style: TextStyle(color: Colors.green.shade900),), backgroundColor: Colors.green.shade100,)
                  );
                  GoRouter.of(context).pushNamed('login');
                }
                } catch(e) {
                  debugPrint("Exception: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Unable to connect to server',)),
                  );
                }
              }
            },
            style: mainBtnStyle(),
            child: const Text('VERIFY EMAIL'),
          )
        ],
      )
    );
  }

  String? codeValidator(value) {
            debugPrint("Validating..");
            if (value == null || value.isEmpty) {
              return 'Please Enter the Verification Code';
            }
            return null;
          }
}


// -------------------------------------------TOKEN MANAGEMENT ---------------------------------------------------

Future<void> storeToken(String token) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('login_token', token);

  //
  debugPrint('Saved Token');
  String? result = await getToken();
  debugPrint('Proving.. $result');
}

Future<String?> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('login_token');
}

Future<void> removeToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('login_token');
} 



// --------------------------------------------- CONSTANTS -------------------------------------------------------


// TextStyle labelStyle() => const TextStyle(color: colorGreen, fontWeight: FontWeight.w400, fontFamily: 'public sans', fontSize: 15);

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

  ButtonStyle mainBtnStyle() => ButtonStyle(
    fixedSize: WidgetStateProperty.all<Size>(const Size(177, 64)),
    backgroundColor: WidgetStateProperty.all<Color>(colorGreen),
    foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)))
  );

const colorGreen = Color.fromRGBO(19, 72, 62, 1);
const colorBg = Color.fromRGBO(231, 232, 227, 1);

