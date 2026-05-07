class AppProductPropertires {
  final String id;
  final String propertyOfWhatId;
  final String propertyName;
  final String propertyHandler;
  final Map<String, String>? attributes;
  final Map<String, String>? data;

  AppProductPropertires({
    required this.id,
    required this.propertyOfWhatId,
    required this.propertyName,
    required this.propertyHandler,
    this.attributes,
    this.data,
  });

  factory AppProductPropertires.intial() => AppProductPropertires(
    id: '',
    propertyOfWhatId: '',
    propertyName: '',
    propertyHandler: '',
  );
}
