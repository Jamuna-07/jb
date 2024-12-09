import 'package:jain_buzz/auth.dart';
import 'package:flutter/material.dart';
import 'package:jain_buzz/constants/color.dart';
import 'package:jain_buzz/containers/custom_input_form.dart';
import 'package:jain_buzz/views/homepage.dart';
import 'package:jain_buzz/views/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 80,
            ),
            const Text(
              "Login",
              style: TextStyle(
                  color: kLightGreen,
                  fontSize: 32,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomInputForm(
                controller: _emailController,
                icon: Icons.email_outlined,
                label: "Email",
                hint: "Enter your Email"),
            const SizedBox(
              height: 8,
            ),
            CustomInputForm(
                obscureText: true,
                controller: _passwordController,
                icon: Icons.lock_outline_rounded,
                label: "Password",
                hint: "Enter your Password"),
            const SizedBox(
              height: 8,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Forget Password",
                  style: TextStyle(
                      color: kLightGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  loginUser(_emailController.text, _passwordController.text)
                      .then((value) {
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Login Successful !!!")));

                      Future.delayed(
                          const Duration(seconds: 2),
                          () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Homepage())));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Login Failed Try Again.")));
                    }
                  });
                },
                style: OutlinedButton.styleFrom(
                    foregroundColor: kLightGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: Text("Login"),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SignUpPage())),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Create a New Account ?",
                    style: TextStyle(
                        color: kLightGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    "Sign Up",
                    style: TextStyle(
                        color: kLightGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  loginUser(String text, String text2) {}
}
