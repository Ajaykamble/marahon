import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:marathon/Models/tracking_model.dart';
import 'package:marathon/screen/route_path_screen.dart';
import 'package:marathon/screen/widgets/home_tracking_card.dart';
import 'package:marathon/services/background_service.dart';
import 'package:marathon/services/location_service.dart';
import 'package:marathon/services/permission_service.dart';
import 'package:marathon/utils/app_color_scheme.dart';
import 'package:marathon/utils/app_values.dart';
import 'package:marathon/utils/enums.dart';
import 'package:marathon/viewModel/homeProvider.dart';
import 'package:marathon/viewModel/userProvider.dart';
import 'package:marathon/widget/custom_error_widget.dart';
import 'package:marathon/widget/primary_filled_button.dart';
import 'package:marathon/widget/space_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BackgroundService _backgroundServiceProvider;
  late HomeProvider _homeProvider;

  @override
  void initState() {
    super.initState();
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    _backgroundServiceProvider = Provider.of<BackgroundService>(context, listen: false);
    _backgroundServiceProvider.resetProvider();
    _homeProvider.resetProvider();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      loadData();
    });
  }

  startTracking() async {
    int battery = await PermissionService().enableBatteryOptimization(context);
    int status = await LocationService.locationServiceInstance.checkPermission(context);
    if (status == 1 && context.mounted && battery == 1) {
      _backgroundServiceProvider.startService();
    }
  }

  loadData() {
    _homeProvider.getTrackingData(userId: UserProvider().userid ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: AppColorScheme.kPrimaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppValues.kAppPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Selector<HomeProvider, Tuple3<ApiStatus, int, List<TrackingModel>>>(
                selector: (context, provider) => Tuple3(provider.getTrackingStatus, provider.userTrackList.length, provider.userTrackList),
                builder: (context, _, __) {
                  if (_homeProvider.getTrackingStatus == ApiStatus.LOADING) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (_homeProvider.getTrackingStatus == ApiStatus.SUCCESS) {
                    return ListView.separated(
                      separatorBuilder: (context, index) => const SpaceWidget(
                        height: 8,
                      ),
                      itemCount: _homeProvider.userTrackList.length,
                      itemBuilder: (context, index) {
                        return HomeTrackingCard(
                          model: _homeProvider.userTrackList[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RoutePathScreen(
                                  model: _homeProvider.userTrackList[index],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return CustomErrorWidget(onRetry: loadData);
                  }
                },
              ),
            ),
            Selector<BackgroundService, Tuple2<ApiStatus, bool>>(
              selector: (context, provider) => Tuple2(provider.trackingStatus, provider.isServiceRunning),
              builder: (context, _, __) {
                return SizedBox(
                  width: double.infinity,
                  child: PrimaryFilledButton(
                    buttonTitle: _backgroundServiceProvider.isServiceRunning ? "Stop Tracking" : "Start Tracking",
                    onPressed: startTracking,
                    isLoading: _backgroundServiceProvider.trackingStatus == ApiStatus.LOADING,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
