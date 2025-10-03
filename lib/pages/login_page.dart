import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_portfolio/provider/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../widgets/responsive_header.dart';
import '../widgets/mobile_drawer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _showOtpField = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // Format phone with +91
  String _formatPhone(String phone) {
    return "+91${phone.trim()}";
  }

  bool get _isPhoneValid => _phoneController.text.trim().length == 10;
  bool get _isOtpValid => _otpController.text.trim().length == 6;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      endDrawer: isMobile ? const MobileDrawer() : null,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE0F7FA), Color(0xFFE1F5FE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          const Align(alignment: Alignment.topCenter, child: ResponsiveHeader()),
          Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Sign in with Phone",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Enter your number to get a verification code",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 30),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _showOtpField ? _buildOtpField(auth) : _buildPhoneField(auth),
                    ),
                    // Recaptcha container for Web
                    if (kIsWeb && !_showOtpField)
                      Container(key: const Key('recaptcha'), height: 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneField(AuthProvider auth) {
    return Column(
      key: const ValueKey(0),
      children: [
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // allow only numbers
            LengthLimitingTextInputFormatter(10), // max 10 digits
          ],
          decoration: InputDecoration(
            labelText: "Phone Number",
            hintText: "Enter 10-digit number",
            prefixText: "+91 ",
            prefixIcon: const Icon(Icons.phone),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) {
            setState(() {}); // refresh button enable/disable
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: auth.isLoading || !_isPhoneValid
              ? null
              : () {
                  auth.sendOtp(
                    phoneNumber: _formatPhone(_phoneController.text),
                    context: context,
                    onCodeSent: () {
                      setState(() => _showOtpField = true);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text("OTP Sent!")));
                    },
                    onError: (err) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(err)));
                    },
                  );
                },
          child: auth.isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Send OTP"),
        ),
      ],
    );
  }

  Widget _buildOtpField(AuthProvider auth) {
    return Column(
      key: const ValueKey(1),
      children: [
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            labelText: "Enter OTP",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (_) {
            setState(() {}); // refresh button enable/disable
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: auth.isLoading || !_isOtpValid
              ? null
              : () {
                  auth.verifyOtp(
                    smsCode: _otpController.text.trim(),
                    onSuccess: () {
                      if (context.mounted) context.go('/'); // Navigate home
                    },
                    onError: (err) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(err)));
                    },
                  );
                },
          child: auth.isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Verify & Login"),
        ),
      ],
    );
  }
}
