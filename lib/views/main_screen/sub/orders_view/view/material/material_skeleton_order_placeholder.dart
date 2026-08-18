import 'package:crabpay/views/custom_ui_elements/ui_utilities.dart';
import 'package:flutter/material.dart';

class MaterialSkeletonOrderPlaceHolder extends StatelessWidget {
  const MaterialSkeletonOrderPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Card(
        elevation: 4,
        color: context.appColorScheme.surfaceContainerLowest,
        margin: .all(0),
        shape: RoundedRectangleBorder(
          borderRadius: .circular(16),
          side: BorderSide(
            color: context.appColorScheme.outline.withValues(alpha: .2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            spacing: 8,
            children: [
              Container(
                margin: const .only(bottom: 8),
                padding: const .symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: context.appColorScheme.surfaceContainerLow,
                  borderRadius: .circular(12),
                ),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: .circular(8),
                            color:
                                context.appColorScheme.surfaceContainerHighest,
                          ),
                          child: Text(
                            'wer 23, qf32 | 23:43',
                            style: const TextStyle(
                              fontWeight: .w600,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: .circular(8),
                            color:
                                context.appColorScheme.surfaceContainerHighest,
                          ),
                          child: Text(
                            'Order: eijslo93ie',
                            style: TextStyle(color: Colors.transparent),
                          ),
                        ),
                      ],
                    ),
                    Builder(
                      builder: (context) {
                        return IconButton(
                          onPressed: null,
                          icon: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: .circular(8),
                                  color: context
                                      .appColorScheme
                                      .surfaceContainerHighest,
                                ),
                                child: Text(
                                  'Support',
                                  style: TextStyle(color: Colors.transparent),
                                ),
                              ),
                              Icon(
                                Icons.square_rounded,
                                color: context
                                    .appColorScheme
                                    .surfaceContainerHighest,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: .start,
                children: [
                  Container(
                    margin: .symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: .circular(8),
                      color: context.appColorScheme.surfaceContainerHighest,
                    ),
                    height: 40,
                    width: 44 * 5,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: .circular(8),
                            color:
                                context.appColorScheme.surfaceContainerHighest,
                          ),
                          child: Text(
                            'Delivered',
                            style: TextStyle(color: Colors.transparent),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: .circular(8),
                            color:
                                context.appColorScheme.surfaceContainerHighest,
                          ),
                          child: Text(
                            '2',
                            style: TextStyle(color: Colors.transparent),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: .circular(8),
                            color:
                                context.appColorScheme.surfaceContainerHighest,
                          ),
                          child: Text(
                            'Products',
                            style: TextStyle(color: Colors.transparent),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: .circular(8),
                            color:
                                context.appColorScheme.surfaceContainerHighest,
                          ),
                          child: Text(
                            '2',
                            style: TextStyle(color: Colors.transparent),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: .circular(8),
                            color:
                                context.appColorScheme.surfaceContainerHighest,
                          ),
                          child: Text(
                            'order PRice',
                            style: TextStyle(color: Colors.transparent),
                          ),
                        ),
                        Container(
                          width: 32,
                          decoration: BoxDecoration(
                            borderRadius: .circular(8),
                            color:
                                context.appColorScheme.surfaceContainerHighest,
                          ),
                          child: Text(
                            '3',
                            style: TextStyle(color: Colors.transparent),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
