enum CreateCommandName {
  project,
  page,
  controller,
  view,
  provider,
}

class CreateModel {
  final String? name;
  final String? path;
  final String? commandName;
  final List<String> createCommandList = [
    'Project',
    'Page',
    'Controller',
    'View',
    'Provider',
    /*CreateCommandData(
      title: 'Project',
      commandName: CreateCommandName.project,
    ),
    CreateCommandData(
      title: 'Page',
      commandName: CreateCommandName.page,
    ),
    CreateCommandData(
      title: 'Controller',
      commandName: CreateCommandName.controller,
    ),
    CreateCommandData(
      title: 'View',
      commandName: CreateCommandName.view,
    ),
    CreateCommandData(
      title: 'Provider',
      commandName: CreateCommandName.provider,
    ),*/
  ];

  CreateModel({
    this.name,
    this.path,
    this.commandName,
  });
}

class CreateCommandData {
  final String title;
  final CreateCommandName? commandName;

  CreateCommandData({
    required this.title,
    this.commandName,
  });
}
