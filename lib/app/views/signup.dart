import 'package:fireduino/app/network/request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/establishment.dart';
import '../utils/dialog.dart';
import '../controllers/signup.dart';
import '../custom/decoration.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CreateAccountController>();

    return WillPopScope(
      onWillPop: () async {
        bool canPop = true;

        // Check if the user has entered any information
        if (ctrl.currentStep.value > 0 || ctrl.firstName.value.isNotEmpty || ctrl.lastName.value.isNotEmpty) {
          // Ask the user if they want to cancel creating an account
          await showAppDialog("Cancel Account?", "Are you sure you want to cancel creating an account?", actions: [
            TextButton(
              child: const Text("No"),
              onPressed: () {
                canPop = false;
                Get.back();
              }
            ),
            TextButton(
              child: const Text("Yes, cancel"),
              onPressed: () {
                canPop = true;
                ctrl.reset();
                Get.back();
              },
            ),
          ]);
        }

        return canPop;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create Account"),
        ),
        body: Obx(() => Stepper(
          steps: [
            Step(
              isActive: ctrl.currentStep.value == 0,
              state: ctrl.currentStep.value == 0 ? StepState.editing : StepState.complete,
              title: StepTextTitle(context, "Step 1", ctrl.currentStep.value == 0),
              subtitle: const Text("Personal Information"),
              content: const Personal()
            ),
            Step(
              isActive: ctrl.currentStep.value == 1,
              state: ctrl.currentStep.value == 1 ? StepState.editing : ctrl.maxStep.value < 1 ? StepState.disabled : StepState.complete,
              title: StepTextTitle(context, "Step 2", ctrl.currentStep.value == 1),
              subtitle: const Text("Contact Information"),
              content: const Contact()
            ),
            Step(
              isActive: ctrl.currentStep.value == 2,
              state: ctrl.currentStep.value == 2 ? StepState.editing : ctrl.maxStep.value < 2 ? StepState.disabled : StepState.complete,
              title: StepTextTitle(context, "Step 3", ctrl.currentStep.value == 2),
              subtitle: const Text("Establishment Information"),
              content: const Establishment()
            ),
            Step(
              isActive: ctrl.currentStep.value == 3,
              state: ctrl.currentStep.value == 3 ? StepState.editing : ctrl.maxStep.value < 3 ? StepState.disabled : StepState.complete,
              title: StepTextTitle(context, "Step 4", ctrl.currentStep.value == 3),
              subtitle: const Text("Account Information"),
              content: const Account()
            ),
          ],
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(
                    onPressed: details.onStepContinue,
                    child: const Text("Continue"),
                  ),
                ],
              ),
            );
          },
          currentStep: ctrl.currentStep.value,
          onStepContinue: () async {
            final currentStep = ctrl.currentStep.value;
    
            // Personal
            if (currentStep == 0) {
              // Check if first name is empty
              if (ctrl.firstName.value.isEmpty) {
                showAppDialog("First name empty", "Please enter your first name");
                return;
              }
    
              // Check if last name is empty
              if (ctrl.lastName.value.isEmpty) {
                showAppDialog("Last name empty", "Please enter your last name");
                return;
              }
    
              return ctrl.nextStep();
            }
    
            // Contact
            if (currentStep == 1) {
              // Check if email is empty
              if (ctrl.email.value.isEmpty) {
                showAppDialog("Email empty", "Please enter your email");
                return;
              }

              // Check if email is valid
              if (!ctrl.email.value.isEmail) {
                showAppDialog("Invalid email", "Please enter a valid email");
                return;
              }

              return ctrl.nextStep();
            }
            
            // Establishment
            if (currentStep == 2) {
              // Show loading dialog
              showLoader("Verifying establishment...");
              // Check if establishment exists
              final bool isValid = await FireduinoAPI.verifyInviteKey(ctrl.establishmentId.value, ctrl.inviteKey.value);
              // Close loading dialog
              Get.back();

              // Check if establishment exists
              if (isValid) {
                // Go to next step
                return ctrl.nextStep();
              }

              // Show error dialog
              showAppDialog("Error", FireduinoAPI.message);
            }
          },
          onStepCancel: () {
    
          },
          onStepTapped: (step) {
            ctrl.currentStep.value = step;
          },
        )
      )),
    );
  }
}

/// Custom Text Widget for Step Title
class StepTextTitle extends Text {
  StepTextTitle(BuildContext context, String label, bool isActive, {super.key}) :
    super(label, style: TextStyle(
      fontWeight: FontWeight.w500,
      color: isActive ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.outline,
    )
  );
}

class Personal extends StatelessWidget {
  const Personal({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CreateAccountController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          TextField(
            maxLength: 32,
            keyboardType: TextInputType.name,
            decoration: CustomInputDecoration(
              context: context,
              labelText: "First Name",
              prefixIcon: const Icon(Icons.person_outlined),
            ),
            onChanged: (value) {
              ctrl.firstName.value = value;
            },
          ),
          const SizedBox(height: 16),
          TextField(
            maxLength: 32,
            keyboardType: TextInputType.name,
            decoration: CustomInputDecoration(
              context: context,
              labelText: "Last Name",
              prefixIcon: const Icon(Icons.person_outlined),
            ),
            onChanged: (value) {
              ctrl.lastName.value = value;
            },
          ),
        ],
      ),
    );
  }
}

class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CreateAccountController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          TextField(
            maxLength: 32,
            keyboardType: TextInputType.emailAddress,
            decoration: CustomInputDecoration(
              context: context,
              labelText: "Email",
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            onChanged: (value) {
              ctrl.email.value = value;
            },
          ),
        ],
      ),
    );
  }
}

class Establishment extends StatelessWidget {
  const Establishment({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CreateAccountController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          SearchAnchor(
            isFullScreen: false,
            builder: (context, controller) {
              return  TextField(
                maxLength: 32,
                keyboardType: TextInputType.text,
                readOnly: true,
                controller: controller,
                decoration: CustomInputDecoration(
                  context: context,
                  labelText: "Select Establishment",
                  prefixIcon: const Icon(Icons.business_outlined),
                ),
                onTap: () {
                  controller.openView();
                },
              );
            },
            suggestionsBuilder: (context, controller) {
              if (controller.text.isEmpty) {
                return [
                  const Center(
                    child: Text("Enter establishment name"),
                  )
                ];
              }

              return [
                FutureBuilder(
                  future: FireduinoAPI.fetchEstablishments(controller.text),
                  builder: (context, snapshot) {

                    if (snapshot.hasData) {
                      final establishments = snapshot.data as List<EstablishmentModel>;

                      // Check if establishments is empty
                      if (establishments.isEmpty) {
                        return const Center(
                          child: Text("No establishment found"),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: establishments.length,
                        itemBuilder: (context, index) {
                          final establishment = establishments[index];

                          return ListTile(
                            title: Text(establishment.name ?? "..."),
                            onTap: () {
                              ctrl.establishmentId.value = establishment.id != null ? establishment.id.toString() : "";
                              controller.closeView(establishment.name);
                            },
                          );
                        },
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                )
              ];
            }
          ),
          const SizedBox(height: 16),
          TextField(
            maxLength: 8,
            keyboardType: TextInputType.text,
            decoration: CustomInputDecoration(
              context: context,
              labelText: "Enter Invitation Key",
              prefixIcon: const Icon(Icons.key),
            ),
            onChanged: (value) {
              ctrl.inviteKey.value = value;
            },
          )
        ],
      ),
    );
  }
}

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CreateAccountController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          TextField(
            maxLength: 32,
            keyboardType: TextInputType.text,
            decoration: CustomInputDecoration(
              context: context,
              labelText: "Username",
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            onChanged: (value) {
              ctrl.email.value = value;
            },
          ),
          const SizedBox(height: 16),
          TextField(
            maxLength: 32,
            obscureText: true,
            decoration: CustomInputDecoration(
              context: context,
              labelText: "Password",
              prefixIcon: const Icon(Icons.lock_outline_rounded),
            ),
            onChanged: (value) {
              ctrl.email.value = value;
            },
          ),
        ],
      ),
    );
  }
}