# Pincer

## A Tiny Robot Arm for Learning Robotics

### Mobile App Overview

> Pincer is a miniature robot arm project designed for educational purposes in robotics. It offers a
> hands-on experience in understanding and building robotic arms without the risk of those hands
> getting smashed.

This companion mobile app for the Pincer robot arm provides one method of controlling the arm.
Specifically, the app provides an interface for controlling the position of the robot arm's
motors via Bluetooth Low Energy (BLE) communication.

### Project Status: In Development

The Pincer app is currently a work in progress, with several targeted features still under
development. We welcome contributions and ideas from the community to help bring these features to
life.

### Getting Started

There are two methods of obtaining the Pincer mobile app: the app can simply be downloaded from the
Google Play Store or the Apple App Store, or the app can be built from source.

#### Downloading the Mobile App

The Pincer mobile app is available from the Google Play Store and Apple App Store at the following
URLS:

*URLs TBD once app is released*

#### Building From Source

Alternatively, and especially if you wish to make modifications to the mobile app, the mobile app
can be built from source. The Pincer mobile app is built using Flutter, a cross-platform development
framework. To build the app from source, follow these steps:

1. **Install Flutter**: Ensure you have Flutter installed on your system. If not, download and
   install Flutter from [Flutter's official website](https://docs.flutter.dev/get-started/install).
2. **Clone the Repository**: Clone the Pincer app repository from GitHub using the command: git
   clone [GitHub repository URL].
3. **Install Dependencies**: Navigate to the project directory and run ```flutter pub get``` to
   install all the required dependencies.
4. **Run the App**: Run ```flutter run --release``` to build the application. Note: For iOS, you
   must use a MacOS machine and you need to set up a development team in Xcode.
