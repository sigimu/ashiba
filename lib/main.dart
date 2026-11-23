import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/root.dart';

void main() {
  runApp(const ProviderScope(child: Root()));
}
