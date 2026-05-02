class AppProductPropertires {
  final String id;
  final String property;
  final String propertyHandler;
  final Map<String, String> prapertiesGuts;

  AppProductPropertires({
    required this.id,
    required this.property,
    required this.propertyHandler,
    required this.prapertiesGuts,
  });

  factory AppProductPropertires.intial() => AppProductPropertires(
    id: '0',
    property: '',
    propertyHandler: '',
    prapertiesGuts: {},
  );
}
