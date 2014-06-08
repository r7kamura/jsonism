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

# PATCH /apps/1
client.update_app(id: 1, name: "bravo")

# DELETE /apps/1
client.delete_app(id: 1)

# GET /recipes
client.list_recipe

# Each method returns a Jsonism::Response
client.list_app.class #=> Jsonism::Response

# Jsonism::Response has 3 methods: .status, .headers, .body
client.list_app.status #=> 200
client.list_app.headers["Content-Type"] #=> "application/json"
client.list_app.body #=> [#<Jsonism::Resources::App:0x007f871ec96240>]

# Jsonism::Response#body returns an instance of auto-defined class, or ones wrapped in Array
# This class name is assigned from its title property on JSON Schema
client.list_app.body[0].class #=> Jsonism::Resources::App
client.info_app(id: 1).body.class #=> Jsonism::Resources::App

# Auto-defined resource class inherits from Jsonism::Resources::Base
client.list_app.body[0].class.ancestors[1] #=> Jsonism::Resources::Base

# Jsonism::Resources::Base has a method: .to_hash
client.list_app.body[0].to_hash #=> {"id"=>"01234567-89ab-cdef-0123-456789abcdef", "name"=>"example"}

# Resource can respond to .delete method if a link with rel=delete is defined in schema
# DELETE /apps/1
client.list_app.body[0].body.delete

# Resource can also respond to .update method in the same rule
# PATCH /apps/1
resource = client.list_app.body[0]
resource.name = "charlie"
resource.update
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
