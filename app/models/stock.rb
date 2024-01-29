require 'elasticsearch/model'

class Stock < ApplicationRecord
  include Elasticsearch::Model
end
