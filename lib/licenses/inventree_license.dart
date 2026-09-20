import "package:flutter/foundation.dart";

/// The InvenTree app (the open-source project this build is derived
/// from) is MIT licensed. Keep this text exactly as-is — it's the
/// copyright notice MIT requires be included in any copy of the
/// software, including private/internal ones.
const String kInvenTreeLicenseText = '''
MIT License

Copyright (c) 2019 InvenTree

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
''';

/// Registers the InvenTree license text with Flutter's built-in license
/// system, so it shows up on the same "Licenses" page as every other
/// open-source package this app depends on (Flutter aggregates these
/// automatically via showLicensePage / the default About dialog).
void registerInvenTreeLicense() {
  LicenseRegistry.addLicense(() async* {
    yield const LicenseEntryWithLineBreaks(
      ["inventree"],
      kInvenTreeLicenseText,
    );
  });
}