require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'chartkick'
require_relative 'models/historical_rates'
require_relative 'models/rate'

set :bind, '0.0.0.0'
set :port, 8080

class CurrencyDataChallenge < Sinatra::Base
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

    # load the historical rates
    historical_rates = HistoricalRates.new
    chartable_data = historical_rates.to_chartable_format(for_currency: historical_from_currency)

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
      historical_data: chartable_data.data,
      min_value: chartable_data.min_value,
      max_value: chartable_data.max_value,
    }
  end
end
