import 'package:flutter/material.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:provider/provider.dart';
import 'package:spark_save/app/pooling/add_pooling_screen.dart';
import 'package:spark_save/app/pooling/widgets/pooling_list.dart';
import 'package:spark_save/app_state.dart';

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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const AddPoolingScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: DashedBorder.fromBorderSide(
                          dashLength: 10,
                          side:
                              BorderSide(color: Colors.grey.shade500, width: 1),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Add Pooling',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
