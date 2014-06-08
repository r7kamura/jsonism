# Jsonism
Generate HTTP Client from JSON Schema.

## Usage
```ruby
# Prepare JSON Schema for your API
body = File.read("schema.json")
schema = JSON.parse(body)

# Create an HTTP client from JSON Schema which is a Hash object
client = Jsonism::Client.new(schema: schema)
client.methods(false) #=> [:create_app, :delete_app, :info_app, :list_app, :update_app, :list_recipe]

# GET /apps
client.list_app

# GET /apps/1
client.info_app(id: 1)

# POST /apps
client.create_app(name: "alpha")

# PUT /apps/1
client.update_app(id: 1, name: "bravo")

# DELETE /apps/1
client.delete_app(id: 1)

# GET /recipes
client.list_recipe
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
