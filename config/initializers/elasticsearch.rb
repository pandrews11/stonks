Elasticsearch::Model.client = Elasticsearch::Client.new(
  host: 'elasticsearch',
  log: true
)
