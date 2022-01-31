import 'package:flutter/material.dart';
import 'package:minimal_adhan/extensions.dart';
import 'package:minimal_adhan/models/Tasbih.dart';
import 'package:minimal_adhan/prviders/TasbihProvider.dart';
import 'package:minimal_adhan/widgets/EditText.dart';
import 'package:minimal_adhan/widgets/iconedTextButton.dart';
import 'package:provider/src/provider.dart';

class CreateTasbihScreen extends StatefulWidget {
  const CreateTasbihScreen({Key? key}) : super(key: key);

  @override
  State<CreateTasbihScreen> createState() => _CreateTasbihScreenState();
}

class _CreateTasbihScreenState extends State<CreateTasbihScreen> {
  bool infinite = true;
  var name = '';
  var target = '';

  void _addTasbih (BuildContext context, TasbihProvider tasbihProvider){
    try {
      int? tgt;
      if(target.isEmpty && !infinite){
        context.showSnackBar('Please set a target!'); //todo add app local
        return;
      }else if (!infinite){
        try{
          tgt = int.parse(target);
        }catch(e){
          context.showSnackBar('Please enter a valid target!');
          return;
        }
      }

      if(name.isEmpty){
        context.showSnackBar('Please set a proper name!');
        return;
      }

      if(tgt != null && tgt < 0){
        context.showSnackBar('Please enter a valid target!');
        return;
      }

      final tsbih = Tasbih.create(name: name, target: tgt);
      tasbihProvider.addNewTasbih(tsbih);
      context.pop();
    } catch (e) {
      context.showSnackBar('Error occured!');
    }
  }
  @override
  Widget build(BuildContext context) {
    final tasbihProvider = context.watch<TasbihProvider>();
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Name:',
              style: context.textTheme.headline6,
            ),
          ), //todo app locale
          EditText(
            hint: 'Name of tasbih',
            onChanged: (v) => name = v,
          ),
          //todo add app locale
          CheckboxListTile(
              value: infinite,
              title: Text('No Target'), //todo app locale
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    infinite = val;
                  });
                }
              }),
          if(!infinite)...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Target:',
                style: context.textTheme.headline6,
              ),
            ),

            //todo add app locale
              EditText(
                hint: 'Target',
                inputType: TextInputType.number,
                onChanged: (v)=> target = v,
              )
            //todo add app locale
          ]
        ],
      ),
      actions: [
        IconedTextButton(
          iconData: Icons.check,
          text: 'Done',
          color: Colors.greenAccent,
          onPressed: () => _addTasbih(context, tasbihProvider),
        ),
        IconedTextButton(
          iconData: Icons.cancel,
          text: 'Cancel',
          color: Colors.redAccent,
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
