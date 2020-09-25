require_relative 'currency_layer_connection'

class CurrentRate

  CET = +2

  def self.get(from_currency, to_currency)
    Time.zone = CET
    @from_currency = from_currency
    @to_currency = to_currency
    @current_time = Time.zone.now

    if Rate.count.zero? || Time.zone.now >= Time.zone.now.beginning_of_day + 8.hours
      # if we're at or past 8am CET of current day, fetch the latest rates
      current_date = @current_time.to_date
    else
      # otherwise yesterday's cached rates will do
      # TODO: update the logic, need to account for the case of older dates
      current_date = (@current_time - 1.day).to_date
    end
    (Rate.find_by(date: current_date, from_currency: @from_currency, to_currency: @to_currency) \
      or fetch_current).rate.round(3)
  end

  private

    def self.fetch_current
      current_rate = CurrencyLayerConnection.new.get_rate(@from_currency, @to_currency)
      current_date = @current_time.to_date

      Rate.create(
        date: current_date,
        rate: current_rate,
        from_currency: @from_currency,
        to_currency: @to_currency,
      )
    end
end
