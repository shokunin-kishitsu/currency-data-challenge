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
    erb :currency_selector, layout: :layout_main, locals: { current_rates: current_rates }
end
