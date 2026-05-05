class AppProductPropertires {
  final String id;
  final String propertyOfWhatId;
  final String propertyOfWhatName;
  final Map<String, >
  final List<String> properties;
  final List<String> propertyHandler;
  final Map<String, String>? uIproperties;
  final Map<String, String> expectedOutputData;

  AppProductPropertires({
    required this.id,
    required this.property,
    required this.propertyHandler,
    required this.uIproperties,
    required this.dataProperties,
    required this.propertyOfWhatId,
    required this.propertyOfWhatName,
  });

  factory AppProductPropertires.intial() => AppProductPropertires(
    id: '0',
    property: '',
    propertyHandler: '',
    uIproperties: null,
    dataProperties: null,
    propertyOfWhatId: '',
    propertyOfWhatName: '',
  );
}


