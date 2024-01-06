import 'package:flutter/material.dart';

import 'home.dart';
import 'home_view.dart';

/// Controller for the [HomeRoute] that contains all of the business logic used by this route.
class HomeController extends State<HomeRoute> {
  @override
  Widget build(BuildContext context) => HomeViewLoading(this);
}