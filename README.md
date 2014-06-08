# Jsonism
Generate HTTP Client from JSON Schema.

## Usage
```ruby
# Prepare JSON Schema for your API
body = File.read("schema.json")
schema = JSON.parse(body)

# Create an HTTP client from JSON Schema which is a Hash object
client = Jsonism::Client.new(schema: schema)

# GET /apps
client.list_app

# POST /apps
app = client.create_app(name: "alpha")
app.name = "bravo"

# PUT /apps/:id
app.save

# DELETE /apps/:id
app.delete
```

## Errors
```
StandardError
|
`---Jsonism::Error
    |
    |---Jsonism::Client::BaseUrlNotFound
    |
    `---Jsonism::Request::MissingParams
```
