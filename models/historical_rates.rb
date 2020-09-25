class HistoricalRates
  def initialize
    @rates = seed_rates + saved_rates
  end

  def to_chartable_format(for_currency: 'EUR')
    series_data = @rates.inject({}) do |memo, rate|
      if rate['from_currency'] == for_currency
        conversion_key = "#{rate['from_currency']} to #{rate['to_currency']}"
        if memo[conversion_key].nil?
          memo[conversion_key] = { rate['date'] => rate['rate'].to_f }
        else
          memo[conversion_key][rate['date']] = rate['rate'].to_f
        end
      end
      memo
    end
    rate_values = series_data.values.map { |e| e.values }.flatten
    {
      data: series_data,
      min_rate: rate_values.min.round(3),
      max_value: rate_values.max.round(3),
    }
  end

  private

    def seed_rates
      JSON.parse(File.read("db/seeds/rates.json"))['rates']
    end

    def saved_rates
      Rate.all.map { |rate| rate.as_json }
    end
end
