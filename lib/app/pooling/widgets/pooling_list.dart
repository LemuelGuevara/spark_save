import 'package:flutter/material.dart';
import 'package:spark_save/app/pooling/widgets/pooling_card.dart';
import 'package:spark_save/models/pooling.dart';

class PoolingList extends StatefulWidget {
  final List<Pooling> poolings;

  const PoolingList({
    super.key,
    required this.poolings,
  });

  @override
  State<PoolingList> createState() => _PoolingListState();
}

class _PoolingListState extends State<PoolingList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 10,
        children: widget.poolings.map((pooling) {
          return PoolingCard(pooling: pooling);
        }).toList(),
      ),
    );
  }
}
