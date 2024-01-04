import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
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

  String? dropdownvalue;
  var items = [
    'Walking',
    'Running',
    'Cycling',
  ];

  @override
  void initState() {
    super.initState();
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    _backgroundServiceProvider =
        Provider.of<BackgroundService>(context, listen: false);
    _backgroundServiceProvider.resetProvider();
    _homeProvider.resetProvider();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  startTracking() async {
    if (!_backgroundServiceProvider.isServiceRunning &&
        !_formKey.currentState!.validate()) {
      return;
    }
    if(_backgroundServiceProvider.isServiceRunning)
    {
      log("called0");
      loadData();
    }
    int battery = await PermissionService().enableBatteryOptimization(context);
    int battery1 =
        await PermissionService().enableActivityRecognization(context);
    int status =
        await LocationService.locationServiceInstance.checkPermission(context);
    if (status == 1 && context.mounted && battery == 1) {
      _backgroundServiceProvider.startService(dropdownvalue!);
    }
    
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: "Select Type",
                  contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Select Type";
                  }
                  return null;
                },
                // Initial Value
                value: dropdownvalue,
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),
                // Array list of items
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                },
              ),
              Selector<BackgroundService, Tuple2<ApiStatus, bool>>(
                selector: (context, provider) =>
                    Tuple2(provider.trackingStatus, provider.isServiceRunning),
                builder: (context, _, __) {
                  return SizedBox(
                    width: double.infinity,
                    child: PrimaryFilledButton(
                      buttonTitle: _backgroundServiceProvider.isServiceRunning
                          ? "Stop Tracking"
                          : "Start Tracking",
                      onPressed: startTracking,
                      isLoading: _backgroundServiceProvider.trackingStatus ==
                          ApiStatus.LOADING,
                    ),
                  );
                },
              ),
              Divider(),
              Divider(),
              Expanded(
                child: Selector<HomeProvider,
                    Tuple3<ApiStatus, int, List<TrackingModel>>>(
                  selector: (context, provider) => Tuple3(
                      provider.getTrackingStatus,
                      provider.userTrackList.length,
                      provider.userTrackList),
                  builder: (context, _, __) {
                    if (_homeProvider.getTrackingStatus == ApiStatus.LOADING) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (_homeProvider.getTrackingStatus ==
                        ApiStatus.SUCCESS) {
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
            ],
          ),
        ),
      ),
    );
  }
}
