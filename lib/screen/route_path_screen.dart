import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:marathon/Models/tracking_model.dart';
import 'package:marathon/utils/app_assets.dart';
import 'package:marathon/utils/app_color_scheme.dart';
import 'package:marathon/utils/app_values.dart';
import 'package:marathon/utils/enums.dart';
import 'package:marathon/utils/map_tile.dart';
import 'package:marathon/viewModel/homeProvider.dart';
import 'package:marathon/widget/custom_error_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'package:latlong2/latlong.dart';

class RoutePathScreen extends StatefulWidget {
  final TrackingModel model;
  const RoutePathScreen({super.key, required this.model});

  @override
  State<RoutePathScreen> createState() => _RoutePathScreenState();
}

class _RoutePathScreenState extends State<RoutePathScreen> {
  late HomeProvider _homeProvider;

  @override
  void initState() {
    super.initState();
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    _homeProvider.resetRoutePathScreen();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
  }

  loadData() async {
    await _homeProvider.getTrackingPathData(
      userId: widget.model.userid ?? "",
      trackingId: widget.model.trackingid ?? "",
      marathonId: widget.model.marathonid ?? "",
    );
  }

  final mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Route Path"),
      ),
      body: Selector<HomeProvider, Tuple5<ApiStatus, int, List<TrackingModel>, int, List<LatLng>>>(
        selector: (p0, p1) => Tuple5(p1.getPathStatus, p1.userPathTrackList.length, p1.userPathTrackList, p1.latLonList.length, p1.latLonList),
        builder: (context, value, child) {
          if (value.item1 == ApiStatus.LOADING) {
            return const Center(child: CircularProgressIndicator());
          } else if (value.item1 == ApiStatus.SUCCESS) {
            if (_homeProvider.userPathTrackList.isEmpty) {
              return const Center(child: Text("No Data Found"));
            } else {
              return FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: _homeProvider.latLonList.first,
                  zoom: 12.0,
                ),
                children: [
                  openStreetMapTileLayer,
                  PolylineLayer(
                    polylines: [
                      Polyline(points: _homeProvider.latLonList, color: AppColorScheme.kPrimaryColor, strokeWidth: 2.0, strokeJoin: StrokeJoin.round),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 40.0,
                        height: 40.0,
                        point: _homeProvider.latLonList.first,
                        builder: (ctx) => SvgPicture.asset(
                          AppAssets.icLocationPin,
                          colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                        ),
                      ),
                      Marker(
                        width: 40.0,
                        height: 40.0,
                        point: _homeProvider.latLonList.last,
                        builder: (ctx) => SvgPicture.asset(
                          AppAssets.icLocationPin,
                          colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          } else {
            return CustomErrorWidget(
              onRetry: loadData,
            );
          }
        },
      ),
    );
  }
}
