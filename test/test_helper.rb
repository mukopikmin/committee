require "minitest"
require "minitest/spec"
require "minitest/autorun"
#require "pry-rescue/minitest"
require "rack/test"
require "rr"

require_relative "../lib/committee"

# The OpenAPI sample specification provided directly from the organization uses
# a couple custom "format" values for JSON schema, namely "int32" and "int64".
# Provide basic definitions for them here so that we don't error when trying to
# parse the sample.
JsonSchema.configure do |c|
  c.register_format 'int32', ->(data) {}
  c.register_format 'int64', ->(data) {}
end

# For our hyper-schema example.
ValidApp = {
  "maintenance" => false,
  "name"        => "example",
}.freeze

# For our OpenAPI example.
ValidPet = {
  "id"   => 123,
  "name" => "example",
  "tag"  => "tag-123",
}.freeze

def hyper_schema
  @hyper_schema ||= begin
    driver = Committee::Drivers::HyperSchema.new
    driver.parse(hyper_schema_data)
  end
end

def open_api_2_schema
  @open_api_2_schema ||= begin
    driver = Committee::Drivers::OpenAPI2.new
    driver.parse(open_api_2_data)
  end
end

# Don't cache this because we'll often manipulate the created hash in tests.
def hyper_schema_data
  JSON.parse(File.read("./test/data/hyperschema/paas.json"))
end

# Don't cache this because we'll often manipulate the created hash in tests.
def open_api_2_data
  JSON.parse(File.read("./test/data/openapi2/petstore-expanded.json"))
end
