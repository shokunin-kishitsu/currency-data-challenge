require_relative 'currency_layer_connection'

class Rate < ActiveRecord::Base
  validates_presence_of :date
  validates_presence_of :rate
  validates_presence_of :from_currency
  validates_presence_of :to_currency

  CET = +2

  def self.current(from_currency, to_currency)
    Time.zone = CET
    if Rate.count.zero? || Time.zone.now >= Time.zone.now.beginning_of_day + 8.hours
      # if we're at or past 8am CET of current day, fetch the latest rates
      current_date = Time.zone.now.to_date
    else
      # otherwise yesterday's cached rates will do
      # TODO: update the logic, need to account for the case of older dates
      current_date = (Time.zone.now - 1.day).to_date
    end
    (Rate.find_by(date: current_date, from_currency: from_currency, to_currency: to_currency) \
      or Rate.fetch_current(from_currency, to_currency)).rate.round(3)
  end

  def self.fetch_current(from_currency, to_currency)
    current_rate = CurrencyLayerConnection.new.get_rate(from_currency, to_currency)
    Time.zone = CET
    current_date = Time.zone.now.to_date

    Rate.create(
      date: current_date,
      rate: current_rate,
      from_currency: from_currency,
      to_currency: to_currency,
    )
  end
end
