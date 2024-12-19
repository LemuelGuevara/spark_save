import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:spark_save/app/pooling/widgets/pooling_details.dart';
import 'package:spark_save/core/utils.dart';
import 'package:spark_save/models/pooling.dart';

class PoolingCard extends StatefulWidget {
  final Pooling pooling;

  const PoolingCard({
    super.key,
    required this.pooling,
  });

  @override
  _PoolingCardState createState() => _PoolingCardState();
}

class _PoolingCardState extends State<PoolingCard> {
  double _opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('MMMM d, yyyy').format(widget.pooling.date.toDate());

    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          showCupertinoModalBottomSheet(
            duration: Duration(milliseconds: 200),
            expand: false,
            useRootNavigator: true,
            context: context,
            builder: (context) => PoolingDetails(
              pooling: widget.pooling,
            ),
          );
        },
        onTapDown: (_) {
          setState(() {
            _opacity = 0.5;
          });
        },
        onTapUp: (_) {
          setState(() {
            _opacity = 1.0;
          });
        },
        onTapCancel: () {
          setState(() {
            _opacity = 1.0;
          });
        },
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            color: Colors.grey.shade50,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        widget.pooling.expenseName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        formatCurrency(widget.pooling.expenseAmount),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.pooling.category,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade800,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "Paid by: ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        widget.pooling.payer,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Badge(
                          backgroundColor: Colors.green.withOpacity(0.2),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 6,
                            ),
                            child: Text(
                              "Members: ${widget.pooling.members.length}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
