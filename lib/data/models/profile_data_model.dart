class ProfileDataModel {
  late String sId;
  late String displayName;
  late String username;
  late List<String> roles;
  late bool active;
  late int experienceYears;
  late String address;
  late String level;
  late String createdAt;
  late String updatedAt;
  late int iV;

  ProfileDataModel(
      {required this.sId,
      required this.displayName,
      required this.username,
      required this.roles,
      required this.active,
      required this.experienceYears,
      required this.address,
      required this.level,
      required this.createdAt,
      required this.updatedAt,
      required this.iV});

  ProfileDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    displayName = json['displayName'];
    username = json['username'];
    roles = json['roles'].cast<String>();
    active = json['active'];
    experienceYears = json['experienceYears'];
    address = json['address'];
    level = json['level'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['displayName'] = displayName;
    data['username'] = username;
    data['roles'] = roles;
    data['active'] = active;
    data['experienceYears'] = experienceYears;
    data['address'] = address;
    data['level'] = level;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
