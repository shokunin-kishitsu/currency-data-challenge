require 'money/bank/currencylayer_bank'
require 'dotenv/load'

class Rate < ActiveRecord::Base
  validates_presence_of :date
  validates_presence_of :rate
  validates_presence_of :currency_from
  validates_presence_of :currency_to

  def self.get_current(currency_from, currency_to)
    mclb = Money::Bank::CurrencylayerBank.new
    mclb.access_key = ENV['ACCESS_KEY']
    Money.default_bank = mclb
    Money.default_bank.get_rate(currency_from, currency_to)
  end
end
