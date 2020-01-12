require 'rails_helper'

RSpec.describe Product, type: :model do
  # Validation tests
  # ensure columns attrs are present before saving
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:stock) }
end
