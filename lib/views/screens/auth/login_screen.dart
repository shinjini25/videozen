import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:videozen/views/screens/auth/signup_screen.dart';
import '../../../constants.dart';
import '../../widgets/text_input.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
            Text(
              "Login",
              style: TextStyle(
                  fontSize: 23,
                  color: secondaryColor,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 25,
            ),

            //<------------------- text fields ------------------->
            Container(
              width: MediaQuery.of(context).size.width,
              margin: kIsWeb
                  ? const EdgeInsets.symmetric(horizontal: 350)
                  : const EdgeInsets.symmetric(horizontal: 25),
              child: TextInputField(
                controller: _emailController,
                labelText: "Enter email",
                icon: Icons.email,
              ),
            ),
            const SizedBox(
              height: 25,
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
              height: 25,
            ),

            //<------------------- Login button ------------------->
            Container(
              width: MediaQuery.of(context).size.width,
              margin: kIsWeb
                  ? const EdgeInsets.symmetric(horizontal: 350)
                  : const EdgeInsets.symmetric(horizontal: 25),
              height: 55,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: InkWell(
                onTap: () => authController.loginUser(
                    _emailController.text, _passwordController.text),
                child: const Text("Log In",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 20)),
              ),
            ),
            const SizedBox(height: 18),

            //<------------------- sign up text row ------------------->
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don\'t have an account? ",
                    style: TextStyle(fontSize: 16)),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SignupScreen()));
                  },
                  child: Text("Register Now!",
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
