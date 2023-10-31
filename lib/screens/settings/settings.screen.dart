import 'package:currency_picker/currency_picker.dart';
import 'package:fintracker/helpers/color.helper.dart';
import 'package:fintracker/helpers/db.helper.dart';
import 'package:fintracker/providers/app_provider.dart';
import 'package:fintracker/widgets/buttons/button.dart';
import 'package:fintracker/widgets/dialog/confirm.modal.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
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
    AppProvider provider = Provider.of<AppProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
        ),
        body: ListView(
          children: [
            ListTile(
              leading: const CircleAvatar(child: Icon(Iconsax.dollar_circle)),
              title: const Text("Currency"),
              subtitle: Selector<AppProvider, String?>(
                  selector: (_, provider)=>provider.currency,
                  builder: (context, state, _) {
                    Currency? currency = CurrencyService().findByCode(state);
                    return Text(currency!.name);
                  }
              ),
              onTap: (){
                showCurrencyPicker(context: context, onSelect: (Currency currency){
                  Provider.of<AppProvider>(context).updateCurrency(currency.code);
                });
              },
            ),
            ListTile(
              onTap: (){
                showDialog(context: context, builder: (context){
                  TextEditingController controller = TextEditingController(text: Provider.of<AppProvider>(context).username);
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
                          TextFormField(
                            controller: controller,
                            decoration: InputDecoration(
                                label: const Text("What should we call you?"),
                                hintText: "Enter your name",
                                filled: true,
                                border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(90),
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
                                    Provider.of<AppProvider>(context).updateUsername(controller.text);
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
              leading: const CircleAvatar(child: Icon(Iconsax.profile_circle5)),
              title: const Text('Name'),
              subtitle: Selector<AppProvider, String?>(
                  selector: (_,provider)=>provider.username,
                  builder: (context, state, _) {
                    return Text(state??"");
                  }
              ),
            ),
            ListTile(
              onTap: () async {
                ConfirmModal.showConfirmDialog(
                    context, title: "Are you sure?",
                    content: const Text("After deleting data can't be recovered"),
                    onConfirm: ()async{
                      Navigator.of(context).pop();
                      await provider.reset();
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
