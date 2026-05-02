import 'package:flutter/material.dart';

class CartPageView extends StatelessWidget {
  const CartPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [TestRadio(), TestDropDownMenu()]);
  }
}

class TestDropDownMenu extends StatefulWidget {
  const TestDropDownMenu({super.key});

  @override
  State<TestDropDownMenu> createState() => _TestDropDownMenuState();
}

class _TestDropDownMenuState extends State<TestDropDownMenu> {
  final List<String> _entries = ['1', '2', '3', '4'];
  final TextEditingController _selectedItem = TextEditingController();
  String selected = '';
  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      onSelected: (value) => setState(() {
        selected = value!;
      }),
      controller: _selectedItem,
      dropdownMenuEntries: <DropdownMenuEntry<String>>[
        DropdownMenuEntry(value: _entries[1], label: _entries[1]),
        DropdownMenuEntry(value: _entries[2], label: _entries[2]),
        DropdownMenuEntry(value: _entries[3], label: _entries[3]),
      ],
    );
  }
}

class TestRadio extends StatefulWidget {
  const TestRadio({super.key});

  @override
  State<TestRadio> createState() => _TestRadioState();
}

class _TestRadioState extends State<TestRadio> {
  String _groupValue = 'roo';
  Map<String, String> radios = {
    'roomba': 'roo',
    'boomba': 'boo',
    'yoomba': 'yoo',
  };

  void radioReacts(String? value) {
    setState(() {
      _groupValue = value ?? 'err';
    });
  }

  List<Widget> choices() {
    List<Widget> resultList = [];
    for (final each in radios.keys) {
      resultList.add(
        InkWell(
          onTap: () => radioReacts(radios[each]),
          child: ListTile(
            title: Text(radios[each]!),
            leading: Radio<String>(value: radios[each]!),
          ),
        ),
      );
    }
    return resultList;
  }

  @override
  Widget build(BuildContext context) {
    return RadioGroup<String>(
      groupValue: _groupValue,
      onChanged: (value) {
        radioReacts(value);
      },
      child: Column(children: choices()),
    );
  }
}
