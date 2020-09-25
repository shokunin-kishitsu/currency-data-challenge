class Rate < ActiveRecord::Base
  validates_presence_of :date
  validates_presence_of :rate
  validates_presence_of :from_currency
  validates_presence_of :to_currency
end
