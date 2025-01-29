require "sinatra"
require "sinatra/reloader"
require "http"
require "json"
require_relative "env_test" # Load environment variables

# Homepage route
get("/") do
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch('EXCHANGE_RATE_KEY')}"
  response = HTTP.get(api_url)

  if response.status.success?
    parsed_data = JSON.parse(response.to_s)
    @currencies = parsed_data["symbols"] || {}
  else
    @currencies = {}
  end

  erb :layout
end

# Route for a single currency
get("/:from_currency") do
  @from_currency = params.fetch("from_currency")
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch('EXCHANGE_RATE_KEY')}"
  response = HTTP.get(api_url)

  if response.status.success?
    parsed_data = JSON.parse(response.to_s)
    @currencies = parsed_data["symbols"] || {}
  else
    @currencies = {}
  end

  erb :single_currency
end

# Route for converting between two currencies
get("/:from_currency/:to_currency") do
  @from_currency = params.fetch("from_currency")
  @to_currency = params.fetch("to_currency")
  api_url = "https://api.exchangerate.host/convert?access_key=#{ENV.fetch('EXCHANGE_RATE_KEY')}&from=#{@from_currency}&to=#{@to_currency}&amount=1"

  response = HTTP.get(api_url)

  if response.status.success?
    parsed_data = JSON.parse(response.to_s)
    @rate = parsed_data["result"]
  else
    @rate = nil
  end

  erb :convert
end
