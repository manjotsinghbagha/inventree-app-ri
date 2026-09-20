import "dart:convert";

import "package:crypto/crypto.dart";
import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:url_launcher/url_launcher.dart";

import "package:inventree/secrets/access_pin_config.dart";

/// Where "I don't have a PIN" sends people. Point this at the official
/// InvenTree app's Play Store listing (or your own landing page).
const String kOfficialAppUrl =
    "https://play.google.com/store/apps/details?id=inventree.inventree_app";

/// Wraps the real app. Shows a one-time PIN screen on first launch;
/// once the correct PIN is entered, remembers that (via secure storage)
/// and never shows the gate again on this device.
class AccessGate extends StatefulWidget {
  const AccessGate({super.key, required this.child});

  final Widget child;

  @override
  State<AccessGate> createState() => _AccessGateState();
}

class _AccessGateState extends State<AccessGate> {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _kGrantedKey = "private_build_access_granted";

  bool _loading = true;
  bool _granted = false;
  bool _busy = false;
  String? _error;
  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkExistingAccess();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _checkExistingAccess() async {
    String? granted;

    try {
      granted = await _storage.read(key: _kGrantedKey);
    } catch (e) {
      // First run on some devices can throw before secure storage is
      // fully initialized — treat as "not granted yet" rather than crash.
      granted = null;
    }

    if (!mounted) return;

    setState(() {
      _granted = granted == "true";
      _loading = false;
    });
  }

  String _hash(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }

  Future<void> _submitPin() async {
    if (kAccessPinHash.isEmpty) {
      setState(() {
        _error = "This app is not set up yet. Please contact your admin.";
      });
      return;
    }

    final String pin = _pinController.text.trim();

    if (pin.isEmpty) {
      setState(() => _error = "Please type your PIN");
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    if (_hash(pin) == kAccessPinHash) {
      await _storage.write(key: _kGrantedKey, value: "true");
      if (!mounted) return;
      setState(() {
        _granted = true;
        _busy = false;
      });
    } else {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = "That's not the right PIN";
        _pinController.clear();
      });
    }
  }

  Future<void> _redirectToOfficialApp() async {
    final Uri uri = Uri.parse(kOfficialAppUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _showNotOfficialExplanation() async {
    final bool? proceed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("This is not the official InvenTree app"),
          content: const Text(
            "This app was made by Ratan Industries, only for our own team "
            "to use. It is not made by, or connected to, the InvenTree "
            "company.\n\n"
            "If you don't have a PIN, this app is not for you. You "
            "probably want the official InvenTree app instead — tap "
            "below to get it.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text("Back"),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text("Get official app"),
            ),
          ],
        );
      },
    );

    if (proceed == true) {
      await _redirectToOfficialApp();
    }
  }

  Future<void> _showLicenses() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    if (!mounted) return;

    showLicensePage(
      context: context,
      applicationName: info.appName,
      applicationVersion: info.version,
      applicationIcon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Image.asset(
          "assets/image/icon.png",
          width: 56,
          height: 56,
        ),
      ),
      applicationLegalese:
          "© ${DateTime.now().year} Ratan Industries\n"
          "Includes the InvenTree app, MIT Licensed",
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_granted) {
      return widget.child;
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/image/icon.png",
                        height: 72,
                        errorBuilder: (context, error, stackTrace) {
                          // Falls back gracefully if the icon can't load
                          // for some reason, instead of crashing the screen.
                          return const Icon(Icons.lock_outline, size: 56);
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Restricted App",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "This app is only for Ratan Industries employees.",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Please enter your PIN to continue.",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _pinController,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        enabled: !_busy,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "PIN",
                          errorText: _error,
                        ),
                        onSubmitted: (_) => _submitPin(),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _busy ? null : _submitPin,
                        child: _busy
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("Unlock"),
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: _showNotOfficialExplanation,
                        child: const Text(
                          "I don't have a PIN",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextButton(
                onPressed: _showLicenses,
                child: const Text(
                  "Licenses",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}