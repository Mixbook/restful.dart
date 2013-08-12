# restful.dart

A Dart package for connecting to restful web services.

## Usage
Import restful.dart.

```
import "package:restful/restful.dart";
```

Create a `RestApi` that points to the root of your API. You can optionally specify an API format, such as JSON.

```
var api = new RestApi(url: "http://www.example.com/myApi", format: JSON);
```

Create a `Resource` to communicate with your API's endpoints.

```
// Maps to http://www.example.com/myApi/users
var usersApi = api.resource("users");
```

Resources support CRUD operations.

```
// Get all users.
// GET /myApi/users
usersApi.findAll();

// Get a user by ID.
// GET /myApi/users/1
usersApi.find(1);

// Create a user
// POST /myApi/users
usersApi.create({"firstName": "John", "lastName": "Doe"});

// Save a user
// PUT /myApi/users/1
usersApi.save(1, "firstName": "Jane", "lastName": "Doe"));

// Delete a user
// DELETE /myApi/users/1
usersApi.delete(1);
```

These operations return a future that contain the deserialized response.

```
usersApi.findAll().then((usersJson) => print("Found users"))
```

### Converting Responses Into Models
A strategy for converting a JSON response into custom model objects is by decorating a resource with a transformer class.

This class might look like:

```
typedef Object ModelFactory(Object response);

class ModelTransform<M> implements Resource {
  Resource _resource;
  ModelFactory _modelFactory;
  
  ModelTransform(this._resource, this._modelFactory);
  
  Future<M> find(id) {
  	return _resource.find(id).then(_transform);
  }
  
  M _transform(Object json) => _modelFactory(json);
  
  // Implement other resource methods here.
}
```

If we wanted to create `User` objects, we'd use our new `ModelTransform` to wrap `userApi`:

```
userApi = new ModelTranform<User>(userApi, (json) => new User()..attributes = json);
```

Now calls to `find()` will return a user model.

```
userApi.find(1).then((user) => print(user is User));
```

Mix and match decorators to create resources that have multiple functionality. For instance, combine our model transformation decorator with a hypothetical decorator to cache API responses:

```
userApi = new ApiCache(
  new ModelTransform(
    api.resource("users"),
    (json) => new User()..attributes = json
  )
);
```