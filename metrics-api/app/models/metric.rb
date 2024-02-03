class Metric < ApplicationRecord
# Validations
  validates :name, presence: true
  validates :value, presence: true, numericality: true
  validates :timestamp, presence: false

  before_save :normalize

  private

  def normalize
    self.name = name.downcase.parameterize
    self.value = value.round(2)
    self.timestamp ||= DateTime.now
  end
end
