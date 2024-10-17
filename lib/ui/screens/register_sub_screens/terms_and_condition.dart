import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Terms and Conditions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '''
             Please read these Terms and Conditions ("Terms", "Terms and Conditions") carefully before using our app (the "Service").

**Acceptance of Terms**
By accessing or using the Service, you agree to be bound by these Terms. If you disagree with any part of the terms, you may not access the Service.

**Accounts**
When you create an account with us, you must provide us information that is accurate, complete, and current at all times. Failure to do so constitutes a breach of the Terms, which may result in immediate termination of your account on our Service.

**User Responsibilities**
You are responsible for safeguarding the password that you use to access the Service and for any activities or actions under your password. You agree not to disclose your password to any third party. You must notify us immediately upon becoming aware of any breach of security or unauthorized use of your account.

**Termination**
We may terminate or suspend your account and bar access to the Service immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.

**Changes to Terms**
We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days' notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.

**Governing Law**
These Terms shall be governed and construed in accordance with the laws of your country, without regard to its conflict of law provisions.

**Contact Us**
If you have any questions about these Terms, please contact us at furbuddysupport@gmail.com.
              ''',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
