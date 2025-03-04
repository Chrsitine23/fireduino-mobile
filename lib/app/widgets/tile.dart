import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FireduinoTile extends StatelessWidget {
  const FireduinoTile({
    required this.index,
    required this.name,
    required this.mac,
    required this.isOnline,
    super.key
  });

  final int index;
  final String name;
  final String mac;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: Get.theme.brightness == Brightness.light ?
        Get.theme.colorScheme.primaryContainer :
        Get.theme.colorScheme.surfaceVariant,
      child: InkWell(
        onTap: () {
          Get.toNamed("/fireduino", parameters: {
            "name": name,
            "mac": mac
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant
                  )),
                  const SizedBox(height: 4),
                  Text(mac.toString(), style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isOnline ?
                          Get.theme.brightness == Brightness.light ?
                            Colors.teal.shade600 :
                            Colors.teal.shade300 :
                          Get.theme.brightness == Brightness.light ?
                            Colors.red.shade600 :
                            Colors.red.shade300,
                      ),
                    )
                  ],
                )
              )
            ],
          ),
        ),
      )
    );
  }
}