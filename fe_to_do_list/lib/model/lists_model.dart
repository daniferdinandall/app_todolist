// Model untuk mendapatkan data
class ListsModel {
  final String id;
  final String judul;
  final String list;

  ListsModel({
    required this.id,
    required this.judul,
    required this.list,
  });

  factory ListsModel.fromJson(Map<String, dynamic> json) => ListsModel(
        id: json["_id"],
        judul: json["judul"],
        list: json["list"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "judul": judul,
        "list": list,
      };
}

// Model untuk input form
class ListInput {
  final String judul;
  final String list;

  ListInput({
    required this.judul,
    required this.list,
  });

  Map<String, dynamic> toJson() => {
        "judul": judul,
        "list": list,
      };
}

// Model untuk respons
class ListResponse {
  final String? insertedId;
  final String message;
  final int status;

  ListResponse({
    this.insertedId,
    required this.message,
    required this.status,
  });

  factory ListResponse.fromJson(Map<String, dynamic> json) =>
      ListResponse(
        insertedId: json["inserted_id"],
        message: json["message"],
        status: json["status"],
      );
}

class DataItem {
  final String judul;
  final String list;

  DataItem({required this.judul, required this.list});
}
