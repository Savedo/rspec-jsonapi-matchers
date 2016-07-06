# RSpec JSON API matchers

# Installation

Add this line to your application's Gemfile:

```ruby
gem "rspec-jsonapi-matchers", git: "git@github.com:Savedo/rspec-jsonapi-matchers.git", tag: "v0.1.0"
```

## Usage

```ruby
require "rspec/jsonapi/matchers"

describe YourController do
  include RSpec::JsonApi::Matchers

  describe "#index" do
    it "returns error" do
      get :index
      expect(response).to have_jsonapi_error("INVALID")
    end
  end
end
```

## Matchers

have_jsonapi_error:

```ruby
expect(response).to have_jsonapi_error(
  code: "invalid_schema",
  title: "attributes are missing"
)
```

have_jsonapi_resource:
```ruby
expect(response).to have_jsonapi_error("customers", 113", first_name: "John")
```

have_jsonapi_resources:
```ruby
expect(response).to have_jsonapi_resources([
  {
    "id" => "2",
    "type" => "dogs",
    "name" => "Snoopy",
    "owner" => "Charlie"
  },
  {
    "id" => "13",
    "type" => "cats",
    "name" => "Felix"
  }
])
```
