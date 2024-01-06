import 'package:flutter/material.dart';

import 'home_controller.dart';

/// The [HomeRoute] performs initialization tasks for the app including requesting permissions and loading any
/// connections to Pincer robot arms that may have been set up previously.
///
/// When the Pincer app initially launches, there are a number of initializations tasks to be completed. First,
/// because the app uses Bluetooth to connect to nearby Pincer robot arm devices, the app checks that the permissions
/// necessary to use Bluetooth have been granted. If they have not, the app requests these permissions from the user.
/// Second, once a Pincer robot arm is connected to the app/mobile device via Bluetooth, the app saves a record of
/// this device so that it can be automatically connected the next time the app launches. So, another initialization
/// task performed by the [HomeRoute] is to load the list of connected robot arms.
class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  HomeController createState() => HomeController();
}
