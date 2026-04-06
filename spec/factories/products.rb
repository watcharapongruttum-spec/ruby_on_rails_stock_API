FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    price    { 100.0 }
    stock    { 10 }
    category { 'electronics' }
  end
end
