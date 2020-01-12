class Product < ApplicationRecord
    validates :name, presence: true
    validates :description, presence: true
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
    
    def stock_should_be_greater_than_or_equal_to_0
      if stock < 0
        errors.add(:stock, "Error #13 - Stock negativo")
      end
    end
end
