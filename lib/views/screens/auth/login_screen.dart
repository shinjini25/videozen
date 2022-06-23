import 'package:flutter/material.dart';

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
              "Videozen",
              style: TextStyle(
                  color: buttonColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w900),
            ),
            const Text(
              "Login",
              style: TextStyle(
                  // color: buttonColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 25),
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
              margin: const EdgeInsets.symmetric(horizontal: 25),
              child: TextInputField(
                controller: _emailController,
                labelText: "Enter Password",
                icon: Icons.lock,
                isObscure: true,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 25),
              height: 55,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: InkWell(
                onTap: () {},
                child: const Text("Log In",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 20)),
              ),
            ),
            SizedBox(height: 18),
            //sign up row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don\'t have an account? ",
                    style: TextStyle(fontSize: 16)),
                InkWell(
                  onTap: () {},
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
