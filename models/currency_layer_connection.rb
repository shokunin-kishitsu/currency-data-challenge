require 'money/bank/currencylayer_bank'
require 'dotenv/load'

class CurrencyLayerConnection

  CURRENCY_LAYER_ACCESS_KEY = ENV['ACCESS_KEY']

  def initialize
    Money.default_bank = Money::Bank::CurrencylayerBank.new
    Money.default_bank.access_key = CURRENCY_LAYER_ACCESS_KEY
  end

  def get_rate(from_currency, to_currency)
    Money.default_bank.get_rate(from_currency, to_currency)
  end
end
