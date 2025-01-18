// ignore_for_file: file_names

class ToDosDataModel {
  late String sId;
  late String image;
  late String title;
  late String desc;
  late String priority;
  late String status;
  late String user;
  late String createdAt;
  late String updatedAt;
  late int iV;

  ToDosDataModel(
      {required this.sId,
      required this.image,
      required this.title,
      required this.desc,
      required this.priority,
      required this.status,
      required this.user,
      required this.createdAt,
      required this.updatedAt,
      required this.iV});

  ToDosDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    image = json['image'];
    title = json['title'];
    desc = json['desc'];
    priority = json['priority'];
    status = json['status'];
    user = json['user'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['image'] = image;
    data['title'] = title;
    data['desc'] = desc;
    data['priority'] = priority;
    data['status'] = status;
    data['user'] = user;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
