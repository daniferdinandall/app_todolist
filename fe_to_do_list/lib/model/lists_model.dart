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
  final int createdat;

  ListInput({
    required this.title,
    required this.description,
    required this.duedate,
    required this.priority,
    required this.createdat,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "duedate": duedate,
        "priority": priority,
        "createdat": createdat,
      };
}

// Model untuk respons
class ListResponse {
  final String? insertedId;
  final String message;
  final int status;
  final int duedate;
  final int priority;
  final int createdat;

  ListResponse({
    this.insertedId,
    required this.message,
    required this.status,
    required this.duedate,
    required this.priority,
    required this.createdat,
  });

  factory ListResponse.fromJson(Map<String, dynamic> json) =>
      ListResponse(
        insertedId: json["inserted_id"],
        message: json["message"],
        status: json["status"],
        duedate: json["duedate"],
        priority: json["priority"],
        createdat: json["createdat"],
      );
}

class DataItem {
  final String title;
  final String description;
  final int duedate;
  final int priority;
  final int createdat;

  DataItem({
    required this.title, 
    required this.description,
    required this.duedate,
    required this.priority,
    required this.createdat,
  });
}
