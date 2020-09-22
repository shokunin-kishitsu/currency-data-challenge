require 'sinatra'
require 'money/bank/currencylayer_bank'
require 'dotenv/load'

# Listen on all interfaces in the development environment
# This is needed when we run from Cloud 9 environment
# source: https://gist.github.com/jhabdas/5945768
set :bind, '0.0.0.0'
set :port, 8080

get '/' do

    mclb = Money::Bank::CurrencylayerBank.new
    mclb.access_key = ENV['ACCESS_KEY']
    mclb.update_rates

    base_currency = mclb.source

    erb :currency_selector, layout: :layout_main, locals: { base_currency: base_currency }
end
