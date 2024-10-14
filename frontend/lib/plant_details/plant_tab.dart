import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/change_notifiers.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/info_entries.dart';
import 'package:plant_it/plant_details/gallery.dart';
import 'package:plant_it/toast/toast_manager.dart';
import 'package:provider/provider.dart';

class PlantDetailsTab extends StatefulWidget {
  final PlantDTO plant;
  final Environment env;

  const PlantDetailsTab({
    super.key,
    required this.plant,
    required this.env,
  });

  @override
  State<PlantDetailsTab> createState() => _PlantDetailsTabState();
}

class _PlantDetailsTabState extends State<PlantDetailsTab> {
  late UniqueKey _galleryKey = UniqueKey();

  Future<bool> _updatePlantAvatarImage(String imageId) async {
    if (imageId != widget.plant.avatarImageId) {
      return _setNewAvatarImage(imageId);
    } else {
      return _removeAvatarImage();
    }
  }

  Future<bool> _setNewAvatarImage(String imageId) async {
    final PlantDTO updated = PlantDTO.fromJson(widget.plant.toMap());
    updated.avatarMode = "SPECIFIED";
    updated.avatarImageId = imageId;
    final response =
        await widget.env.http.put("plant/${updated.id}", updated.toMap());
    final responseBody = json.decode(response.body);
    if (response.statusCode != 200) {
      widget.env.logger.error(
          "Error while setting image id $imageId as plant avatar: ${responseBody["message"]}");
      if (!mounted) return false;
      widget.env.toastManager.showToast(context, ToastNotificationType.error,
          AppLocalizations.of(context).errorUpdatingPlant);
      return false;
    }
    widget.env.logger.info("Plant avatar successfully updated");
    if (!mounted) return false;
    widget.env.toastManager.showToast(context, ToastNotificationType.success,
        AppLocalizations.of(context).plantUpdatedSuccessfully);
    setState(() {
      widget.plant.avatarMode = "SPECIFIED";
      widget.plant.avatarImageId = imageId;
    });
    return true;
  }

  Future<bool> _removeAvatarImage() async {
    final PlantDTO updated = PlantDTO.fromJson(widget.plant.toMap());
    updated.avatarMode = "NONE";
    updated.avatarImageId = null;
    final response =
        await widget.env.http.put("plant/${updated.id}", updated.toMap());
    final responseBody = json.decode(response.body);
    if (response.statusCode != 200) {
      widget.env.logger.error(
          "Error while removing plant avatar: ${responseBody["message"]}");
      if (!mounted) return false;
      widget.env.toastManager.showToast(context, ToastNotificationType.error,
          AppLocalizations.of(context).errorUpdatingPlant);
      return false;
    }
    widget.env.logger.info("Plant avatar successfully updated");
    if (!mounted) return false;
    widget.env.toastManager.showToast(context, ToastNotificationType.success,
        AppLocalizations.of(context).plantUpdatedSuccessfully);
    setState(() {
      widget.plant.avatarMode = "NONE";
      widget.plant.avatarImageId = null;
    });
    return true;
  }

  Future<bool> _deletePlantPhotoWithConfirm(
      BuildContext context, String imageId) async {
    final Completer<bool> completer = Completer<bool>();
    showDialog<bool>(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).pleaseConfirm),
            content: Text(AppLocalizations.of(context).areYouSureToRemovePhoto),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _deletePlantPhoto(imageId).then((success) {
                    completer.complete(success);
                  });
                },
                child: Text(AppLocalizations.of(context).yes),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  completer.complete(false);
                },
                child: Text(AppLocalizations.of(context).no),
              ),
            ],
          );
        });

    return completer.future;
  }

  Future<bool> _deletePlantPhoto(String imageId) async {
    try {
      final response = await widget.env.http.delete(
        "image/$imageId",
      );
      if (!mounted) return false;
      if (response.statusCode != 200) {
        final responseBody = json.decode(response.body);
        widget.env.logger.error(responseBody["message"]);
        throw AppException(responseBody["message"]);
      }
    } catch (e, st) {
      widget.env.logger.error(e, st);
      throw AppException.withInnerException(e as Exception);
    }
    widget.env.logger.info("Photo successfully deleted");
    widget.env.toastManager.showToast(context, ToastNotificationType.success,
        AppLocalizations.of(context).photoSuccessfullyDeleted);
    return true;
  }

  String? _calculateAndFormatAge(BuildContext context, DateTime birthday) {
    final timePassed = DateTime.now().difference(birthday);
    if (timePassed.inDays == 0) {
      return AppLocalizations.of(context).newBorn;
    } else if (timePassed.inDays < 30) {
      if (timePassed.inDays > 0) {
        return AppLocalizations.of(context).nDays(timePassed.inDays);
      } else {
        return AppLocalizations.of(context)
            .nDaysInFuture(timePassed.inDays.abs());
      }
    } else if (timePassed.inDays < 365) {
      final months = timePassed.inDays ~/ 30;
      final remainingDays = timePassed.inDays % 30;
      if (remainingDays == 0) {
        return AppLocalizations.of(context).nMonths(months);
      } else {
        return AppLocalizations.of(context)
            .nMonthsAndDays(months, remainingDays);
      }
    } else {
      final years = timePassed.inDays ~/ 365;
      final remainingMonths = (timePassed.inDays % 365) ~/ 30;
      final remainingDays = (timePassed.inDays % 365) % 30;
      if (remainingMonths == 0 && remainingDays == 0) {
        return AppLocalizations.of(context).nYears(years);
      } else if (remainingMonths == 0) {
        return AppLocalizations.of(context).nYearsAndDays(years, remainingDays);
      } else if (remainingDays == 0) {
        return AppLocalizations.of(context)
            .nYearsAndMonths(years, remainingMonths);
      } else {
        return AppLocalizations.of(context)
            .nYearsAndMonthsAndDays(years, remainingMonths, remainingDays);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<PhotosNotifier>(context, listen: false).addListener(() {
      setState(() {
        _galleryKey = UniqueKey();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          InfoGroup(
            title: AppLocalizations.of(context).info,
            children: [
              SimpleInfoEntry(
                title: AppLocalizations.of(context).name,
                value: widget.plant.info.personalName,
              ),
              SimpleInfoEntry(
                title: AppLocalizations.of(context).birthday,
                value: widget.plant.info.startDate != null
                    ? formatDate(DateTime.parse(widget.plant.info.startDate!))
                    : null,
              ),
              SimpleInfoEntry(
                  title: AppLocalizations.of(context).age,
                  value: widget.plant.info.startDate != null
                      ? _calculateAndFormatAge(
                          context, DateTime.parse(widget.plant.info.startDate!))
                      : null),
              SimpleInfoEntry(
                title: AppLocalizations.of(context).avatar,
                value: widget.plant.avatarMode!.toLowerCase(),
              ),
              FullWidthInfoEntry(
                title: AppLocalizations.of(context).note,
                value: widget.plant.info.note,
              ),
              SimpleInfoEntry(
                  title: AppLocalizations.of(context).purchasedPrice,
                  value: widget.plant.info.purchasedPrice == null
                      ? null
                      : (widget.plant.info.purchasedPrice!.toString() +
                          (widget.plant.info.currencySymbol ?? ""))),
              SimpleInfoEntry(
                  title: AppLocalizations.of(context).seller,
                  value: widget.plant.info.seller.toString()),
              SimpleInfoEntry(
                  title: AppLocalizations.of(context).location,
                  value: widget.plant.info.location.toString()),
            ],
          ),
          InfoGroup(
            title: AppLocalizations.of(context).gallery,
            children: [
              Gallery(
                env: widget.env,
                key: _galleryKey,
                plant: PlantDTO.fromJson(widget.plant.toMap()),
                removePhoto: _deletePlantPhotoWithConfirm,
                setAvatar: _updatePlantAvatarImage,
                avatarImageId: widget.plant.avatarImageId,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
