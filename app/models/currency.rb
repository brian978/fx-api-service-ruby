class Currency < ApplicationRecord
  BRIDGE_CURRENCY = 'RON'

  validates :name, presence: true, uniqueness: true
  has_many :rates, dependent: :destroy

  scope :lookup, -> (currency_name) { where(name: currency_name).first! }

  # @param date_time [DateTime]
  def rate (date_time)
    date_time.change({ hour: 0, min: 0, sec: 0 })

    if BRIDGE_CURRENCY.eql? name
      return rates.new(value: 1)
    end

    rates.lookup(date_time.strftime('%Y-%m-%d')).first!
  end
end
