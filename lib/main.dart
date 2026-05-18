import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://qzypcqbynemnoyyuymxx.supabase.co',
    anonKey: 'sb_publishable_jQSyTR8AvxcsiI8QXZCbuQ_eRmzS96V',
  );
  runApp(const KerebtaApp());
}
