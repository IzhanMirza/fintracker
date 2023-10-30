import 'package:currency_picker/currency_picker.dart';
import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/helpers/color.helper.dart';
import 'package:fintracker/helpers/db.helper.dart';
import 'package:fintracker/theme/colors.dart';
import 'package:fintracker/widgets/buttons/button.dart';
import 'package:fintracker/widgets/dialog/confirm.modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:settings_ui/settings_ui.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
      ),
        body: ListView(
          children: [
            ListTile(
              leading: const CircleAvatar(child: Icon(Iconsax.dollar_circle)),
              title: const Text("Currency"),
              subtitle: BlocBuilder<AppCubit, AppState>(builder: (context, state) {
                Currency? currency = CurrencyService().findByCode(state.currency!);
                return Text(currency!.name);
              }),
              onTap: (){
                showCurrencyPicker(context: context, onSelect: (Currency currency){
                  context.read<AppCubit>().updateCurrency(currency.code);
                });
              },
            ),
            ListTile(
              onTap: (){
                showDialog(context: context, builder: (context){
                  TextEditingController controller = TextEditingController(text: context.read<AppCubit>().state.username);
                  return AlertDialog(
                    title: const Text("Profile", style: TextStyle(fontWeight: FontWeight.w600),),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width - 60 < 500 ? MediaQuery.of(context).size.width - 60 : 500,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("What should we call you?", style: theme.textTheme.bodyLarge!.apply(color: ColorHelper.darken(theme.textTheme.bodyLarge!.color!), fontWeightDelta: 1),),
                          const SizedBox(height: 15,),
                          TextFormField(
                            controller: controller,
                            decoration: InputDecoration(
                                label: const Text("Name"),
                                hintText: "Enter your name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15)
                            ),
                          )
                        ],
                      ),
                    ),
                    actions: [
                      Row(
                        children: [
                          Expanded(
                              child: AppButton(
                                onPressed: (){
                                  if(controller.text.isEmpty){
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter name")));
                                  } else {
                                    context.read<AppCubit>().updateUsername(controller.text);
                                    Navigator.of(context).pop();
                                  }
                                },
                                height: 45,
                                label: "Save",
                              )
                          )
                        ],
                      )
                    ],
                  );
                });
              },
              leading: const CircleAvatar(child: Icon(Iconsax.user)),
              title: const Text('Name'),
              subtitle: BlocBuilder<AppCubit, AppState>(builder: (context, state) {
                return Text(state.username??"");
              }),
            ),
            ListTile(
              onTap: () async {
                ConfirmModal.showConfirmDialog(
                    context, title: "Are you sure?",
                    content: const Text("After deleting data can't be recovered"),
                    onConfirm: ()async{
                      await context.read<AppCubit>().reset();
                      await resetDatabase();
                    },
                    onCancel: (){
                      Navigator.of(context).pop();
                    }
                );
              },
              leading: const CircleAvatar(child: Icon(Iconsax.profile_delete)),
              title: const Text('Reset'),
              subtitle: const Text("Delete all the data"),
            ),
          ],
        )
    );
  }
}
