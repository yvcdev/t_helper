import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/functions/functions.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/utils/utils.dart';
import 'package:t_helper/widgets/widgets.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({Key? key}) : super(key: key);

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  final subjectTextController = TextEditingController();

  @override
  dispose() {
    super.dispose();
    SubjectController subjectController = Get.find();
    subjectController.editionMode.value = false;
  }

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
                          Obx(() => TextFormField(
                                controller: subjectTextController,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(20)
                                ],
                                autocorrect: false,
                                decoration: InputDecorations.generalInputDecoration(
                                    labelText:
                                        'Subject Name ${subjectController.editionMode.value ? "(edition mode)" : ""}',
                                    hintText: 'Subject Name',
                                    prefixIcon: Icons.text_fields_rounded,
                                    labelColor:
                                        subjectController.editionMode.value
                                            ? CustomColors.red
                                            : null),
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
                              )),
                          Positioned(
                            right: 5,
                            top: 10,
                            child: IconButton(
                                onPressed: () async {
                                  if (subjectController.editionMode.value) {
                                    int index = subjectController.subjectList
                                        .indexWhere((subject) =>
                                            subject.id ==
                                            subjectController
                                                .subjectToDelete.value);

                                    await subjectsOnSendNewNamePressed(
                                        context,
                                        subjectController.subjectToDelete.value,
                                        subjectTextController.text,
                                        index,
                                        formKey,
                                        subjectTextController);
                                  } else {
                                    await subjectsOnAddPressed(context, formKey,
                                        listKey, subjectTextController);
                                  }
                                },
                                icon: const Icon(
                                  Icons.send,
                                  color: CustomColors.primary,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: subjectController.editionMode.value,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            subjectController.editionMode.value
                                ? 'Editing "${subjectController.subjectList.firstWhere((subject) => subject.id == subjectController.subjectToDelete.value).name}"'
                                : '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: UiConsts.smallFontSize,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomTextButton(
                                  onPressed: () async {
                                    await subjectOnDeleteSubjectPressed(
                                        context,
                                        subjectController.subjectToDelete.value,
                                        subjectTextController,
                                        listKey,
                                        _offset);
                                  },
                                  title: 'Delete Subject'),
                              CustomTextButton(
                                  onPressed: () {
                                    subjectController.editionMode.value = false;
                                    subjectTextController.text = '';
                                    formKey.currentState!.validate();
                                    addSubjectForm.reset();
                                    FocusScope.of(context).unfocus();
                                  },
                                  title: 'Cancel')
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: subjectController.editionMode.value ? 2 : 20,
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
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                UiConsts.borderRadius - 5),
                            gradient: LinearGradient(colors: [
                              UiConsts.colors[index % UiConsts.colors.length],
                              UiConsts.colors[index % UiConsts.colors.length]
                                  .withOpacity(0.9)
                            ])),
                        child: GetBuilder<SubjectController>(
                            builder: (controller) => Row(
                                  children: [
                                    Expanded(
                                      child: SwitchListTile(
                                        contentPadding: const EdgeInsets.only(
                                            right: 0,
                                            top: 4,
                                            left: 15,
                                            bottom: 4),
                                        value: controller
                                            .subjectList[index].active,
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
                                        tileColor: UiConsts.colors[
                                            index % UiConsts.colors.length],
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          subjectOnEditPress(
                                              context,
                                              controller.subjectList[index].id!,
                                              controller
                                                  .subjectList[index].name,
                                              index,
                                              subjectTextController);
                                          formKey.currentState!.validate();
                                        },
                                        icon: const Icon(
                                          Icons.edit_rounded,
                                          color: Colors.white,
                                        ))
                                  ],
                                )),
                      ),
                    );
                  },
                ),
              ),
            ]));
  }
}
