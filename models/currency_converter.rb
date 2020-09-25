class CurrencyConverter
  def convert(amount, from_currency, to_currency)
    converted_amount = amount.to_f * Rate.current(from_currency, to_currency) * 100
    conversion_result = Money.new(converted_amount, to_currency)
  end
end
