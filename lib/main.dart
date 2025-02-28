import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app/bloc.dart';
import 'package:map_app/src/data/datasources/service/geolocator_service.dart';
import 'package:map_app/src/data/datasources/service/shared_pref.dart';
import 'package:map_app/src/data/repositories/map_repo.dart';
import 'package:map_app/src/presentation/bloc/map_bloc/map_bloc_bloc.dart';
import 'package:map_app/src/presentation/views/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper.init();
  Bloc.observer = SimpleBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapBloc(MapRepo(service: GeoLocatorService()))
        ..add(GetLocationOnDevice()),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
