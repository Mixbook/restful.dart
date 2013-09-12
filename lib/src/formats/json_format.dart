part of restful.formats;

class JsonFormat extends Format {

  JsonFormat() : super("application/json");

  Object deserialize(String response) {
    // The Dart JSON parser blows up on empty responses.
    return response != null && response.length > 0 ? JSON.decode(response) : {};
  }

  String serialize(Object object) {
    return JSON.encode(object);
  }

}