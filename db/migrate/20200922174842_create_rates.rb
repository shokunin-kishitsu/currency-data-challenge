class CreateRates < ActiveRecord::Migration[6.0]
  def change
    create_table :rates do |t|
      t.date    :date
      t.decimal :rate
      t.string  :from_currency
      t.string  :to_currency
    end
  end
end
