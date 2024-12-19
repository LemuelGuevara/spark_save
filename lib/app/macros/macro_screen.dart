import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark_save/app/macros/widgets/macro_form.dart';
import 'package:spark_save/app/macros/widgets/macro_list.dart';
import 'package:spark_save/app_state.dart';
import 'package:spark_save/presentation/widgets/buttons/add_item_button.dart';

class MacrosScreen extends StatelessWidget {
  const MacrosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) {
        return SingleChildScrollView(
          child: Center(
            child: Column(
              spacing: 10,
              children: <Widget>[
                MacroList(macros: appState.macros),
                AddItemButton(
                  title: 'Add Macro',
                  redirectTo: const MacroForm(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
