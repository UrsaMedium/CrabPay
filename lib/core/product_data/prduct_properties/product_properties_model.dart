class AppProductPropertires {
  final String id;
  final String propertyOfWhatId;
  final String propertyOfWhatName;
  final List<String> properties;
  final List<String> propertyHandler;
  final Map<String, String>? uIproperties;
  final Map<String, String> expectedOutputData;

  AppProductPropertires({
    required this.id,
    required this.propertyHandler,
    required this.uIproperties,
    required this.propertyOfWhatId,
    required this.propertyOfWhatName,
    required this.properties,
    required this.expectedOutputData,
  });

  factory AppProductPropertires.intial() => AppProductPropertires(
    id: '0',
    propertyHandler: [],
    uIproperties: null,
    propertyOfWhatId: '',
    propertyOfWhatName: '',
    properties: [],
    expectedOutputData: {},
  );
}
