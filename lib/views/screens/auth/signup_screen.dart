import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:videozen/views/screens/auth/login_screen.dart';
import '../../../constants.dart';
import '../../widgets/text_input.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Application",
              style: TextStyle(
                  color: buttonColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w900),
            ),
            const SizedBox(
              height: 25,
            ),

            //<------------------- Avatar and uplaod img icon ------------------->
            Stack(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png'),
                  backgroundColor: Colors.grey,
                ),
                Positioned(
                  bottom: 30,
                  left: 28,
                  child: IconButton(
                    icon:
                        const Icon(Icons.upload, color: Colors.black, size: 34),
                    onPressed: () => authController.pickImage(),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),

            //<------------------- text fields ------------------->
            Container(
              width: MediaQuery.of(context).size.width,
              margin: kIsWeb
                  ? const EdgeInsets.symmetric(horizontal: 350)
                  : const EdgeInsets.symmetric(horizontal: 25),
              child: TextInputField(
                controller: _emailController,
                labelText: "Enter Email",
                icon: Icons.email,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: kIsWeb
                  ? const EdgeInsets.symmetric(horizontal: 350)
                  : const EdgeInsets.symmetric(horizontal: 25),
              child: TextInputField(
                controller: _usernameController,
                labelText: "Enter Username",
                icon: Icons.person,
                isObscure: false,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: kIsWeb
                  ? const EdgeInsets.symmetric(horizontal: 350)
                  : const EdgeInsets.symmetric(horizontal: 25),
              child: TextInputField(
                controller: _passwordController,
                labelText: "Enter Password",
                icon: Icons.lock,
                isObscure: true,
              ),
            ),
            const SizedBox(
              height: 15,
            ),

            //<------------------- sign up button ------------------->
            Container(
              width: MediaQuery.of(context).size.width,
              margin: kIsWeb
                  ? const EdgeInsets.symmetric(horizontal: 350)
                  : const EdgeInsets.symmetric(horizontal: 25),
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: InkWell(
                onTap: () async {
                  String res = await authController.registerUser(
                      _usernameController.text,
                      _emailController.text,
                      _passwordController.text,
                      authController.profilePhoto);

                  //redirect to login if sign up is successful
                  if (res == "success") {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  }
                },
                child: const Text("Sign up",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 20)),
              ),
            ),
            const SizedBox(height: 18),

            //<------------------- login text row ------------------->
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? ",
                    style: TextStyle(fontSize: 16)),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text("Login",
                      style: TextStyle(fontSize: 18, color: secondaryColor)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
