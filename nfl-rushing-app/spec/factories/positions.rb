FactoryBot.define do
  factory :position do
    name { 'POS' }

    factory :qb do
      name { 'QB' }
    end

    factory :rb do
      name { 'RB' }
    end
  end
end
