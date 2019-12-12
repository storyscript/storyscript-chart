when http server listen path: "/" as request
    name = request.queryParams.get(key: "name" default: "world")
    request write content: "hello {name}!"
