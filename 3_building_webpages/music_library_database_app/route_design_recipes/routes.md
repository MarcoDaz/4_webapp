# Albums resource:

## List all the albums
```
Request:
GET /albums

Response:
list of albums
```

## Read a single album
```
Request:
GET /albums/1

Response:
of a single album
```

## Create a new album
```
Request:
POST /albums
  With body parameters: "title=OK Computer"

Response:
None (just creates the resource on the server)
```

## Update a single album
```
Request:
PATCH /albums/1
  With body parameters: "title=OK Computer"

Response:
None (just updates the resource on the server)
```

## Delete an album
```
Request:
DELETE /albums/1

Response:
None (just deletes the resource on the server)
```