# Ratan Industries InvenTree App

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This is a **private, customized fork** of the official
[InvenTree mobile app](https://github.com/inventree/inventree-app),
rebuilt and rebranded for internal use at **Ratan Industries**.

> **This is not the official InvenTree app.** It is not affiliated with,
> distributed by, or supported by the InvenTree project. If you're
> looking for the official app, see [Official InvenTree App](#official-inventree-app)
> below.

Written in [Flutter](https://flutter.dev/), it provides native Android
support and connects to our internal InvenTree stock management server.

<p align="center">
  <img width="30%" src="https://github.com/user-attachments/assets/aee96f90-2953-47f6-916a-06f19d3b8aa5">
</p>

## What's different from upstream

This fork keeps all core InvenTree app functionality intact, with the
following changes layered on top:

- **Branding** — app name, icon, and splash screen updated to Ratan
  Industries' identity
- **Preset server URL** — the app is pre-configured to point at our
  internal InvenTree instance on first launch
- **Access gate** — a one-time PIN screen shown on first launch,
  restricting the app to authorized Ratan Industries staff. Anyone
  without a PIN is shown a clear notice that this isn't the official
  app, with a link to get the real one instead
- **Theme** — colors adjusted to match Ratan Industries branding

No core InvenTree functionality has been removed or altered — this is a
distribution/branding layer, not a functional fork.

## Installation

This app is **not published publicly**. It's distributed internally to
Ratan Industries staff only, via one of:

- A signed APK shared directly (sideloaded)
- An internal/closed testing track on Google Play, restricted to
  approved Ratan Industries accounts

If you're a Ratan Industries employee and don't have access, contact
your IT/admin contact for the current build and access PIN.

## Official InvenTree App

If you're not looking for a Ratan Industries internal tool, you
probably want the official InvenTree app instead:

- [Official InvenTree App on Google Play](https://play.google.com/store/apps/details?id=inventree.inventree_app)
- [Official InvenTree App source (GitHub)](https://github.com/inventree/inventree-app)
- [InvenTree stock management system](https://github.com/inventree/InvenTree)

## User Documentation

For how to use the InvenTree app itself (scanning, stock actions,
navigation, etc.), refer to the
[official InvenTree app documentation](https://inventree.readthedocs.io/en/latest/app/app/) —
this fork doesn't change day-to-day usage once you're past the access
screen.

## Developer / Build Documentation

This fork is built independently of InvenTree's own CI/release process.
See [`BUILDING.md`](BUILDING.md) for:

- Setting up the Flutter/Android build environment
- Generating and managing the app signing keystore
- Building a signed release APK/AAB
- Where the branding, preset server URL, and theme customizations live
  in source, and how to adjust them
- How the access-PIN gate works and how to configure it
- Adding your own logo/splash assets

## License

This project is a derivative of the [InvenTree app](https://github.com/inventree/inventree-app),
licensed under the [MIT License](LICENSE). The original copyright
notice and permission text are preserved in [`LICENSE`](LICENSE), and
also shown in-app under **Settings → About → Licenses**, alongside the
licenses of all third-party packages this app depends on.

Our own additions (branding, access gate, configuration) are for
internal Ratan Industries use and are not separately published or
distributed.
