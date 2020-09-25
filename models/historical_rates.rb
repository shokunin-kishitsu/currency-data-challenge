class HistoricalRates
  def initialize
    @rates = seed_rates + saved_rates
  end

  def to_chartable_format(for_currency: 'EUR')
    filtered_rates = @rates.select{ |rate| rate['from_currency'] == for_currency }
    series_data = filtered_rates.inject({}) do |memo, rate|
      conversion_key = "#{rate['from_currency']} to #{rate['to_currency']}"
      memo[conversion_key] ||= {}
      memo[conversion_key][rate['date']] = rate['rate'].to_f
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
