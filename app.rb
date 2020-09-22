require 'sinatra'
require 'sinatra/activerecord'
require 'money/bank/currencylayer_bank'
require 'dotenv/load'

set :bind, '0.0.0.0'
set :port, 8080

get '/' do

    mclb = Money::Bank::CurrencylayerBank.new
    mclb.access_key = ENV['ACCESS_KEY']
    mclb.update_rates

    base_currency = mclb.source

    erb :currency_selector, layout: :layout_main, locals: { base_currency: base_currency }
end
