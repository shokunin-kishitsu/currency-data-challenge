require 'sinatra'
require 'sinatra/activerecord'
require_relative 'models/rate'

set :bind, '0.0.0.0'
set :port, 8080

get '/' do

    #mclb = Money::Bank::CurrencylayerBank.new
    #mclb.access_key = ENV['ACCESS_KEY']
    #mclb.update_rates

    #base_currency = mclb.source
    #current_rate = Rate.get_current('EUR', 'USD')
    current_rates = {
      ['EUR', 'USD'] => 0.45,
      ['USD', 'EUR'] => 0.46,
      ['EUR', 'CHF'] => 0.47,
      ['CHF', 'EUR'] => 0.48,
    }

    erb :currency_selector, layout: :layout_main, locals: { current_rates: current_rates }
end
