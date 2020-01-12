FactoryBot.define do
    factory :product do
        name { Faker::Lorem.word }
        description { Faker::Lorem.paragraph(sentence_count: 2) }
        price { Faker::Number.decimal(l_digits: 2) }
        stock { Faker::Number.number(digits: 10) }
    end
end