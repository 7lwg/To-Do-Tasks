import 'dart:convert';
import 'dart:io';
import 'package:todo_app_task/constants/variables.dart';
import 'package:todo_app_task/data/repository/auth_repo.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app_task/data/models/toDos_data_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
// ignore: depend_on_referenced_packages
import 'package:mime/mime.dart';

String toDosBaseURL = 'https://todo.iraqsapp.com/todos';
String imageUploadBaseURL = 'https://todo.iraqsapp.com/upload/image/';
String imageViewingBaseURL = 'https://todo.iraqsapp.com/images/';
List<ToDosDataModel> toDosDataList = [];
File? selectedImage;

class ToDosRepo {
  Future<dynamic> toDosDataListRepo() async {
    try {
      await getTokens(readAccessToken: true, readRefreshToken: false);
      response = await http.get(
        Uri.parse('$toDosBaseURL?page=$displayedPageOfData'),
        headers: {
          'Content-Type': 'application/json', // Set content type to JSON
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> todosJson = json.decode(response.body);
        if (displayedPageOfData == 1) {
          toDosDataList =
              todosJson.map((todo) => ToDosDataModel.fromJson(todo)).toList();
        } else {
          toDosDataList.addAll(
              todosJson.map((todo) => ToDosDataModel.fromJson(todo)).toList());
        }
      }
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<dynamic> toDosCreateRepo() async {
    try {
      await getTokens(readAccessToken: true, readRefreshToken: false);
      PostData = {
        "image": taskImage,
        "title": taskTitle,
        "desc": taskDescription,
        "priority": taskPriority, //low , medium , high
        "createdAt": displayedTaskDate,
        "updatedAt": displayedTaskDate
      };
      response = await http.post(
        Uri.parse(toDosBaseURL),
        headers: {
          'Content-Type': 'application/json', // Set content type to JSON
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(PostData),
      );
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<dynamic> toDosEditRepo({required toDoID}) async {
    try {
      await getTokens(readAccessToken: true, readRefreshToken: false);
      PostData = {
        "image": taskImage,
        "title": taskTitle,
        "desc": taskDescription,
        "priority": taskPriority, //low , medium , high
      };
      response = await http.put(
        // ignore: prefer_interpolation_to_compose_strings
        Uri.parse(toDosBaseURL + '/' + toDoID),

        headers: {
          'Content-Type': 'application/json', // Set content type to JSON
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(PostData),
      );
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<dynamic> toDosDeleteRepo({required toDoID}) async {
    try {
      await getTokens(readAccessToken: true, readRefreshToken: false);

      response = await http.delete(
        // ignore: prefer_interpolation_to_compose_strings
        Uri.parse(toDosBaseURL + '/' + toDoID),
        headers: {
          'Content-Type': 'application/json', // Set content type to JSON
          'Authorization': 'Bearer $accessToken',
        },
      );
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<dynamic> toDosUploadImageRepo() async {
    try {
      await getTokens(readAccessToken: true, readRefreshToken: false);
      String mimeType = lookupMimeType(selectedImage!.path).toString();

      var request =
          http.MultipartRequest('POST', Uri.parse(imageUploadBaseURL));

      var mediaType = MediaType.parse(mimeType);

      request.headers['Authorization'] = 'Bearer $accessToken';
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        await File(selectedImage!.path).readAsBytes(),
        contentType: mediaType,
        filename: selectedImage!.path.split('/').last,
      ));
      var response1 = await request.send();
      if (response1.statusCode == 201) {
        response = await response1.stream.bytesToString();

        taskImage = imageViewingBaseURL + jsonDecode(response)['image'];
      }
      return response1; // Return the response
    } catch (error) {
      return null;
    }
  }
}
