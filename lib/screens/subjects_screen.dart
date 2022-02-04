import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/controllers/subject_controller.dart';
import 'package:t_helper/functions/functions.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/utils/utils.dart';

class SubjectsScreen extends StatelessWidget {
  SubjectsScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  final subjectTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final addSubjectForm = Get.put(AddSubjectFormController());
    SubjectController subjectController = Get.find();

    Tween<Offset> _offset =
        Tween(begin: const Offset(1, 0), end: const Offset(0, 0));

    return Obx(() => DefaultAppBarLayout(
            scroll: false,
            colunmLayout: true,
            topSeparation: false,
            drawer: false,
            title: 'Subjects',
            loading: subjectController.loading.value,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: UiConsts.largePadding,
                    left: UiConsts.largePadding,
                    right: UiConsts.largePadding),
                decoration: BoxDecoration(
                    color: Colors.white, boxShadow: [UiConsts.boxShadow]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create a subject',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: UiConsts.smallFontSize,
                          color: Colors.black),
                    ),
                    Text(
                      subjectController.subjectNumber.value == 1
                          ? 'You have ${subjectController.subjectNumber} subject'
                          : 'You have ${subjectController.subjectNumber} subjects',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: UiConsts.tinyFontSize,
                          color: subjectController.subjectNumber.value == 0
                              ? CustomColors.red
                              : CustomColors.green),
                    ),
                    Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Stack(
                        children: [
                          TextFormField(
                            controller: subjectTextController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(20)
                            ],
                            autocorrect: false,
                            decoration: InputDecorations.generalInputDecoration(
                                hintText: 'Subject Name',
                                labelText: 'Subject Name',
                                prefixIcon: Icons.text_fields_rounded),
                            validator: (value) {
                              String pattern = r'^[a-zA-Z1-9ñÑ\s]*$';
                              RegExp regExp = RegExp(pattern);

                              if (subjectTextController.text != '') {
                                if (value!.trim().length < 3) {
                                  return 'The name should have more than 2 characters';
                                }
                                return regExp.hasMatch(value)
                                    ? null
                                    : 'Only alphanumerics and numbers are accepted';
                              }
                            },
                            onChanged: (value) {
                              addSubjectForm.subject = value;
                            },
                          ),
                          Positioned(
                            right: 5,
                            top: 10,
                            child: IconButton(
                                onPressed: () async {
                                  await subjectsOnAddPressed(context, formKey,
                                      listKey, subjectTextController);
                                },
                                icon: const Icon(
                                  Icons.send,
                                  color: CustomColors.primary,
                                )),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedList(
                  key: listKey,
                  initialItemCount: subjectController.subjectList.length,
                  itemBuilder: (context, index, animation) {
                    return SlideTransition(
                      position: animation.drive(_offset),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: UiConsts.smallPadding,
                            vertical: UiConsts.smallPadding),
                        //padding: const EdgeInsets.all(UiConsts.normalPadding),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                UiConsts.borderRadius - 5),
                            gradient: LinearGradient(colors: [
                              UiConsts.colors[index % UiConsts.colors.length],
                              UiConsts.colors[index % UiConsts.colors.length]
                                  .withOpacity(0.9)
                            ])),
                        child: GetBuilder<SubjectController>(
                            builder: (controller) => SwitchListTile(
                                  value: controller.subjectList[index].active,
                                  onChanged: (value) async {
                                    await subjectsOnSwitchChanged(
                                        context,
                                        controller.subjectList[index].id!,
                                        value,
                                        index);
                                  },
                                  title: Text(
                                    controller.subjectList[index].name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: UiConsts.normalFontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                      controller.subjectList[index].active
                                          ? 'Active'
                                          : 'Inactive',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: UiConsts.smallFontSize,
                                      )),
                                  activeColor: Colors.white,
                                  tileColor: UiConsts
                                      .colors[index % UiConsts.colors.length],
                                )),
                      ),
                    );
                  },
                ),
              ),
            ]));
  }
}
