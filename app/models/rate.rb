class Rate < ApplicationRecord
  belongs_to :currency
  belongs_to :ref_currency, class_name: Currency.to_s

  validates :date, presence: true
  validates :value, numericality: true, presence: true
  validates :multiplier, numericality: true, unless: Proc.new { |obj| obj.multiplier.blank? }

  validates_associated :currency, :ref_currency

  scope :lookup, -> (req_date) { where(date: ..req_date).order(date: :desc) }
end
