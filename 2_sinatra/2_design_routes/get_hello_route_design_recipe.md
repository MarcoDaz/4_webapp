# GET /hello Route Design Recipe

## 1. Design the Route Signature

|    What does it do?    | Method |  Path  | Query parameters? | Body parameters? |
|:----------------------:|:------:|:------:|:-----------------:|:----------------:|
| Return a hello message | GET    | /hello | name (string)     | -                |

## 2. Design the Response

The route might return different responses, depending on the result.

For example, a route for a specific blog post (by its ID) might return `200 OK` if the post exists, but `404 Not Found` if the post is not found in the database.

Your response might return plain text, JSON, or HTML code. 

When query param `name` is `Name1`
```
Hello Name1!
```

When query param `name` is `Name2`
```
Hello Name2!
```

## 3. Write Examples

```
# Request:

GET /hello?name=Name1

# Expected response:
Hello Name1!
```

```
# Request:

GET /hello?name=Name2

# Expected response:
Hello Name2!
```

## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "GET /" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('/posts?id=1')

      expect(response.status).to eq(200)
      # expect(response.body).to eq(expected_response)
    end

    it 'returns 404 Not Found' do
      response = get('/posts?id=276278')

      expect(response.status).to eq(404)
      # expect(response.body).to eq(expected_response)
    end
  end
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.