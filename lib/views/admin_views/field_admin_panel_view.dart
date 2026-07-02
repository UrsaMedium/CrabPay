import 'package:flutter/material.dart';

class FieldAdminPanelView extends StatefulWidget {
  static const routeName = 'field_admin_panel_view';
  final String? fieldId;
  const FieldAdminPanelView({super.key, required this.fieldId});

  @override
  State<FieldAdminPanelView> createState() => _FieldAdminPanelViewState();
}

class _FieldAdminPanelViewState extends State<FieldAdminPanelView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
