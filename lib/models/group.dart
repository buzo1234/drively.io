class GroupData {
  String? name;

  List<String?> users = [];

  GroupData(this.name, this.users);

  GroupData.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        users = json['users'];

  Map<String, dynamic> toJson() => {'name': name, 'users': users};
}
