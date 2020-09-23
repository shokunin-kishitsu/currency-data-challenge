require 'money/bank/currencylayer_bank'
require 'dotenv/load'

class Rate < ActiveRecord::Base
  validates_presence_of :date
  validates_presence_of :rate
  validates_presence_of :currency_from
  validates_presence_of :currency_to

  def self.get_current(currency_from, currency_to)
    0.456
  end
end
