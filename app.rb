require 'sinatra'
require 'sinatra/activerecord'
require 'chartkick'
require_relative 'models/rate'

set :bind, '0.0.0.0'
set :port, 8080

get '/' do
  # seed the DB
  historical_data = JSON.parse(File.read("db/seeds/rates.json"))['rates']
  series_data = {}
  historical_data.each do |rate|
    Rate.create(
      date: rate['date'],
      rate: rate['rate'],
      from_currency: rate['from_currency'],
      to_currency: rate['to_currency'],
    )

    conversion_key = "#{rate['from_currency']} to #{rate['to_currency']}"
    if series_data[conversion_key].nil?
      series_data[conversion_key] = { rate['date'] => rate['rate'] }
    else
      series_data[conversion_key][rate['date']] = rate['rate']
    end
  end

  # load the rates from the DB or fetch them from CurrencyLayer
  current_rates = {
    ['EUR', 'USD'] => Rate.current('EUR', 'USD'),
    ['USD', 'EUR'] => Rate.current('USD', 'EUR'),
    ['EUR', 'CHF'] => Rate.current('EUR', 'CHF'),
    ['CHF', 'EUR'] => Rate.current('CHF', 'EUR'),
  }

  # fetch URL params
  conversion_amount = params[:input_value]
  from_currency = params[:from_currency]
  to_currency = params[:to_currency]

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
    historical_data: series_data,
  }
end
