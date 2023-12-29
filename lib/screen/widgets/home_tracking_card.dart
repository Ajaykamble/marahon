import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marathon/Models/tracking_model.dart';
import 'package:marathon/utils/app_color_scheme.dart';
import 'package:marathon/utils/app_styles.dart';
import 'package:marathon/utils/app_values.dart';
import 'package:marathon/utils/extensions/date_extension.dart';

class HomeTrackingCard extends StatefulWidget {
  final TrackingModel model;
  final VoidCallback? onTap;
  const HomeTrackingCard({super.key, required this.model, this.onTap});

  @override
  State<HomeTrackingCard> createState() => _HomeTrackingCardState();
}

class _HomeTrackingCardState extends State<HomeTrackingCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColorScheme.kLightBlueColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(AppValues.kCardPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat(AppValues.dateFormat).format(widget.model.createdAt ?? DateTime.now()),
              style: AppStyles.titleSmall.copyWith(color: AppColorScheme.kGrayColor.shade800),
            ),
          ],
        ),
      ),
    );
  }
}
