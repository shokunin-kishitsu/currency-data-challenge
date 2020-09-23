require 'sinatra'
require 'sinatra/activerecord'
require_relative 'models/rate'

set :bind, '0.0.0.0'
set :port, 8080

get '/' do
  current_rates = {
    ['EUR', 'USD'] => Rate.current('EUR', 'USD'),
    ['USD', 'EUR'] => Rate.current('USD', 'EUR'),
    ['EUR', 'CHF'] => Rate.current('EUR', 'CHF'),
    ['CHF', 'EUR'] => Rate.current('CHF', 'EUR'),
  }

  conversion_amount = params[:input_value]
  from_currency = params[:from_currency]
  to_currency = params[:to_currency]

  if conversion_amount && from_currency && to_currency
    converted_amount = conversion_amount.to_f * Rate.current(from_currency, to_currency)
    conversion_result = Money.new(converted_amount * 100, to_currency).format
  end

  erb :currency_selector, layout: :layout_main, locals: {
    current_rates: current_rates,
    conversion_amount: conversion_amount,
    from_currency: from_currency,
    to_currency: to_currency,
    conversion_result: conversion_result,
  }
end
