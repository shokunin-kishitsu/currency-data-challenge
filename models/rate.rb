class Rate < ActiveRecord::Base
  validates_presence_of :date
  validates_presence_of :rate
  validates_presence_of :currency_from
  validates_presence_of :currency_to
end
