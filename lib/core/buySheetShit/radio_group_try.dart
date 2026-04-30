enum SingingCharacter { lafayette, jefferson }

enum Genre { metal, jazz, blues }

class RadioExample extends StatelessWidget {
  const RadioExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[SingingCharacterRadioGroup(), GenreRadioGroup()],
    );
  }
}

class SingingCharacterRadioGroup extends StatefulWidget {
  const SingingCharacterRadioGroup({super.key});

  @override
  State<SingingCharacterRadioGroup> createState() =>
      SingingCharacterRadioGroupState();
}

class SingingCharacterRadioGroupState
    extends State<SingingCharacterRadioGroup> {
  SingingCharacter? _character = SingingCharacter.lafayette;

  @override
  Widget build(BuildContext context) {
    return RadioGroup<SingingCharacter>(
      groupValue: _character,
      onChanged: (SingingCharacter? value) {
        setState(() {
          _character = value;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Selected: $_character'),
          const ListTile(
            title: Text('Lafayette'),
            leading: Radio<SingingCharacter>(value: SingingCharacter.lafayette),
          ),
          const ListTile(
            title: Text('Thomas Jefferson'),
            leading: Radio<SingingCharacter>(value: SingingCharacter.jefferson),
          ),
        ],
      ),
    );
  }
}

class GenreRadioGroup extends StatefulWidget {
  const GenreRadioGroup({super.key});

  @override
  State<GenreRadioGroup> createState() => GenreRadioGroupState();
}

class GenreRadioGroupState extends State<GenreRadioGroup> {
  Genre? _genre;

  @override
  Widget build(BuildContext context) {
    return RadioGroup<Genre>(
      groupValue: _genre,
      onChanged: (Genre? value) {
        setState(() {
          _genre = value;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Selected: $_genre'),
          const ListTile(
            title: Text('Metal'),
            leading: Radio<Genre>(toggleable: true, value: Genre.metal),
          ),
          const ListTile(
            title: Text('Jazz'),
            leading: Radio<Genre>(value: Genre.jazz),
          ),
          const ListTile(
            title: Text('Blues'),
            leading: Radio<Genre>(value: Genre.blues),
          ),
        ],
      ),
    );
  }
}