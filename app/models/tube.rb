# frozen_string_literal: true

# A Tube
class Tube < ApplicationRecord

  has_one :library
  
  after_create :generate_barcode

  private

  def generate_barcode
    update_column(:barcode, "TRAC-#{self.id}")
  end
end
