enum GenerateCommandName {
  locales,
  model,
}

class GenerateModel {
  final String? name;
  final String? commandName;
  final List<String> generateCommandList = [
    'locales',
    'model',
  ];

  GenerateModel({
    this.name,
    this.commandName,
  });
}

class GenerateCommandData {
  final String title;
  final GenerateCommandName? commandName;

  GenerateCommandData({
    required this.title,
    this.commandName,
  });
}
