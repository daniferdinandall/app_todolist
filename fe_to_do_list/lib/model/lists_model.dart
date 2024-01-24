// Model untuk mendapatkan data
class ListsModel {
  final String id;
  final String title;
  final String description;
  final int duedate;
  final int priority;
  final int createdat;

  ListsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.duedate,
    required this.priority,
    required this.createdat,
  });

  factory ListsModel.fromJson(Map<String, dynamic> json) => ListsModel(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        duedate: json["duedate"],
        priority: json["priority"],
        createdat: json["createdat"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "duedate": duedate,
        "priority": priority,
        "createdat": createdat,
      };
}

// Model untuk input form
class ListInput {
  final String title;
  final String description;
  final int duedate;
  final int priority;

  ListInput({
    required this.title,
    required this.description,
    required this.duedate,
    required this.priority,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "duedate": duedate,
        "priority": priority,
      };
}

// Model untuk respons
class TodolistResponse {
  // final String? token;
  final String message;
  final bool status;

  TodolistResponse({
    // this.token,
    required this.message,
    required this.status,
  });

  factory TodolistResponse.fromJson(Map<String, dynamic> json) =>
      TodolistResponse(
        // token: json["token"],
        message: json["message"],
        status: json["status"],
      );
}


