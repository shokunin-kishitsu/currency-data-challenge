require 'sinatra'
require 'sinatra/activerecord'
require 'chartkick'
require_relative 'models/rate'

set :bind, '0.0.0.0'
set :port, 8080

get '/' do
  # fetch URL params
  conversion_amount = params[:input_value]
  from_currency = params[:from_currency]
  to_currency = params[:to_currency]
  historical_from_currency = params[:historical_from_currency] || 'EUR'

  # load the rates from the DB or fetch them from CurrencyLayer
  current_rates = {
    ['EUR', 'USD'] => Rate.current('EUR', 'USD'),
    ['USD', 'EUR'] => Rate.current('USD', 'EUR'),
    ['EUR', 'CHF'] => Rate.current('EUR', 'CHF'),
    ['CHF', 'EUR'] => Rate.current('CHF', 'EUR'),
  }

  # seed the historical rates
  saved_rates = Rate.all.map { |rate| rate.as_json }
  seed_rates = JSON.parse(File.read("db/seeds/rates.json"))['rates']

  series_data = (saved_rates + seed_rates).inject({}) do |memo, rate|
    if rate['from_currency'] == historical_from_currency
      conversion_key = "#{rate['from_currency']} to #{rate['to_currency']}"
      if memo[conversion_key].nil?
        memo[conversion_key] = { rate['date'] => rate['rate'].to_f }
      else
        memo[conversion_key][rate['date']] = rate['rate'].to_f
      end
    end
    memo
  end
  rate_values = series_data.values.map { |e| e.values }.flatten
  min_value = rate_values.min.round(3)
  max_value = rate_values.max.round(3)

  # perform the conversion
  if conversion_amount && from_currency && to_currency
    converted_amount = conversion_amount.to_f * Rate.current(from_currency, to_currency)
    conversion_result = Money.new(converted_amount * 100, to_currency).format
  end

  # render the template
  erb :currency_selector, layout: :layout_main, locals: {
    current_rates: current_rates,

    conversion_amount: conversion_amount,
    from_currency: from_currency,
    to_currency: to_currency,
    conversion_result: conversion_result,

    historical_from_currency: historical_from_currency,
    historical_data: series_data,
    min_value: min_value,
    max_value: max_value,
  }
end
