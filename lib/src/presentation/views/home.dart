import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map_app/src/presentation/bloc/map_bloc/map_bloc_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          return state is MapLoaded
              ? Column(
                  children: [
                    Expanded(
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: state.positionList.last,
                          initialZoom: 20,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          ),
                          MarkerLayer(
                              markers: state.positionList.map((loc) {
                            return Marker(
                              width: 40,
                              height: 40,
                              point: loc,
                              child: const Icon(Icons.person_pin_circle,
                                  color: Colors.red, size: 30),
                            );
                          }).toList()),
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                  points: state.positionList,
                                  strokeWidth: 4.0,
                                  color: Colors.blue),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              context.read<MapBloc>().add(StopListening());
                            },
                            child: const Text("Konum izlemeyi durdur"),
                          ),
                        ),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              context.read<MapBloc>().add(ListenLocation());
                            },
                            child: const Text("Konum izlemeyi başlat"),
                          ),
                        )
                      ],
                    )
                  ],
                )
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
