import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/options_lists/options_lists.dart';
import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/utils/utils.dart';
import 'package:t_helper/widgets/widgets.dart';
import 'package:t_helper/helpers/helpers.dart';

class GroupInfoScreen extends StatelessWidget {
  const GroupInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CurrentGroupController currentGroupController = Get.find();
    GroupController groupController = Get.find();
    final group = currentGroupController.currentGroup.value;
    final _cards = groupInfoList(context);

    return DefaultAppBarLayout(
        elevation: 0,
        title: 'Group infomation',
        drawer: false,
        topSeparation: false,
        children: [
          Column(
            children: [
              const _HeroInfo(),
              GridSingleCardTwo(
                cards: _cards,
              ),
              const SizedBox(
                height: 20,
              ),
              IconButton(
                  onPressed: () async {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => Obx(() => MinimalPopUp(
                              topImage: false,
                              acceptButtonLabel: 'Yes',
                              cancelButtonLabel: 'No',
                              correctText: 'Delete group?',
                              description:
                                  'Deleting the group will remove all of its information. This action cannot be undone.',
                              onAccept: () async {
                                await groupController.deleteGroup(
                                    group!.id, group.image ?? '');

                                Get.to(() => const RegisteredGroupScreen());
                              },
                              isAcceptActive: !groupController.isLoading.value,
                              isCancelActive: !groupController.isLoading.value,
                              acceptButtonColor: CustomColors.red,
                              onCancel: () {
                                Get.back();
                              },
                            )));
                  },
                  icon: Icon(
                    Icons.delete_forever_rounded,
                    size: UiConsts.extraLargeFontSize,
                    color: CustomColors.red.withOpacity(0.8),
                  )),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ]);
  }
}

class _HeroInfo extends StatelessWidget {
  const _HeroInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CurrentGroupController currentGroupController = Get.find();
    final group = currentGroupController.currentGroup.value;
    return HeroInfo(
      imageUrl: group!.image,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Students: ${group.members}',
              style: TextStyle(
                color:
                    group.members == 0 ? CustomColors.red : CustomColors.green,
                fontSize: UiConsts.smallFontSize,
              ),
            ),
            Text(
              'Activities: ${group.activities.length}',
              style: TextStyle(
                color: group.activities.isEmpty
                    ? CustomColors.red
                    : CustomColors.green,
                fontSize: UiConsts.smallFontSize,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          group.name.toTitleCase(),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: const TextStyle(
            fontSize: UiConsts.largeFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Snackbar.success('Copied', 'The group ID has been copied');
                },
                icon: const Icon(
                  Icons.copy,
                  color: Colors.black87,
                  size: UiConsts.tinyFontSize,
                )),
            Text(
              'ID: ${group.namedId}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: UiConsts.tinyFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          group.subject['name']!.toTitleCase(),
          style: TextStyle(
            fontSize: UiConsts.smallFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
        Text(
          group.level.toCapitalized(),
          style: const TextStyle(
              fontSize: UiConsts.smallFontSize - 2, color: CustomColors.green),
        ),
      ],
    );
  }
}
