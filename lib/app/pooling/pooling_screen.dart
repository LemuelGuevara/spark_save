import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark_save/app/pooling/widgets/pooling_form.dart';
import 'package:spark_save/app/pooling/widgets/pooling_list.dart';
import 'package:spark_save/app_state.dart';
import 'package:spark_save/presentation/widgets/buttons/add_item_button.dart';

class PoolingScreen extends StatelessWidget {
  const PoolingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) {
        return SingleChildScrollView(
          child: Center(
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                PoolingList(poolings: appState.poolings),
                AddItemButton(
                  title: 'Add Pooling',
                  redirectTo: const PoolingForm(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
