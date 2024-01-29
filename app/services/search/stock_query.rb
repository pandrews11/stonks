require 'elasticsearch/dsl'

class Search::StockQuery
  include Elasticsearch::DSL

  def self.call(q)
    new(q).call
  end

  attr_reader :q

  def initialize(q)
    @q = q
  end

  def call
    {
      query: {
        fuzzy: {
          symbol: {
            value: q,
            fuzziness: 2
          }
        }
      }
    }
  end
end
