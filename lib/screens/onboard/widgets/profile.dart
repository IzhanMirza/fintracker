import 'package:currency_picker/currency_picker.dart';
import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/helpers/color.helper.dart';
import 'package:fintracker/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class ProfileWidget extends StatefulWidget{
  final VoidCallback onGetStarted;
  const ProfileWidget({super.key, required this.onGetStarted});

  @override
  State<StatefulWidget> createState() =>_ProfileWidget();
}

class _ProfileWidget extends State<ProfileWidget>{
  final CurrencyService currencyService = CurrencyService();
  String _username = "";
  Currency? _currency;
  @override
  void initState() {
    setState(() {
      _currency = currencyService.findByCode("INR");
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppCubit cubit = context.read<AppCubit>();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding:const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
          children: [
            Text("Hi! \nwelcome to Fintracker", style: theme.textTheme.headlineMedium!.apply(color: theme.colorScheme.primary, fontWeightDelta: 2),),
            const SizedBox(height: 15,),
            Text("Please enter all details to continue.", style: theme.textTheme.bodyLarge!.apply(color: ColorHelper.darken(theme.textTheme.bodyLarge!.color!), fontWeightDelta: 1),),
            const SizedBox(height: 30,),
            Material(
                borderRadius: BorderRadius.circular(100),
                clipBehavior: Clip.hardEdge,
                child:TextFormField(
                  onChanged: (String username)=>setState(() {
                    _username  = username;
                  }),
                  decoration: const InputDecoration(
                      filled: true,
                      border: InputBorder.none,//(borderRadius: BorderRadius.circular(50)),
                      prefixIcon: Icon(Iconsax.user),
                      hintText: "Enter your name",
                      label: Text("What should we call you?")
                  ),
                )
            ),
            const SizedBox(height: 40,),
            Autocomplete<Currency>(
              initialValue: TextEditingValue(text: _currency!=null ? "(${_currency?.code}) ${_currency?.name}":""),
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<Currency>.empty();
                }
                return currencyService.getAll().where((Currency option) {
                  String keyword= textEditingValue.text.toLowerCase();
                  return option.name.toLowerCase().contains(keyword) || option.code.toLowerCase().contains(keyword);
                });
              },
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted){
                return Material(
                  borderRadius: BorderRadius.circular(100),
                  clipBehavior: Clip.hardEdge,
                  child: TextField(controller: controller, focusNode: focusNode, decoration: const InputDecoration(
                      filled: true,
                      border: InputBorder.none,
                      prefixIcon: Icon(Iconsax.dollar_circle),
                      hintText: "Select you currency",
                      label: Text("What will be your default currency?")
                  ),),
                );
              },
              displayStringForOption: (selection)=>"(${selection.code}) ${selection.name}",
              onSelected: (Currency selection) {
                setState(() {
                  _currency = selection;
                });
              },
            ),

            const SizedBox(height: 50,),
            AppButton(
              borderRadius: BorderRadius.circular(100),
              label: "Continue",
              color: theme.colorScheme.inversePrimary,
              isFullWidth: true,
              size: AppButtonSize.large,
              onPressed: (){
                if(_username.isEmpty || _currency == null){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all the details")));
                } else {
                  cubit.update(username: _username, currency: _currency!.code).then((value){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Setup completed")));
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}