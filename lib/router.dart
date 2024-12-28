import 'package:earthquake/main.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import "package:earthquake/earthquake.dart";
import "package:earthquake/info_page.dart";
import "package:earthquake/main.dart";
import "package:earthquake/settings.dart";

final router =
    GoRouter(initialLocation: '/', debugLogDiagnostics: true, routes: [
  GoRoute(
    name: 'home',
     path: '/', 
     builder: (context, state) => EarthQuake()
     ),
  GoRoute(
      path: "/info/:id",
      name: "info",
      builder: (context, state) {
        final jsonName = state.pathParameters['id'];
        return InfoPage(name: jsonName!);
      }),
      GoRoute(
        path: "/settings",
        name: "settings",
        builder: (context, state) => Settings()
      )
]);
