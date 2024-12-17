import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark_save/app/pooling/add_pooling_screen.dart';
import 'package:spark_save/app_state.dart';

class SplitScreen extends StatelessWidget {
  const SplitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) {
        return SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
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
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.green.shade800,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 36),
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
