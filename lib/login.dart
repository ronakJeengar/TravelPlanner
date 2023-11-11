import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:travelapp/Otp.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  // Handle phone number input changes
                },
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.DIALOG,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement OTP sending logic
                // Navigate to the OTP screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const OtpScreen(),
                  ),
                );
              },
              child: const Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
