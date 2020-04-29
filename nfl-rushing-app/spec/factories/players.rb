FactoryBot.define do
  factory :player do
    name { "Player" }
    team
    position

    factory :all_day do
      name { "Adrian Peterson" }
      team factory: :min
      position factory: :rb
    end

    factory :joe_banyard do
      name { "Joe Banyard" }
      team factory: :jax
      position factory: :rb
    end

    factory :shaun_hill do
      name { "Shaun Hill" }
      team factory: :min
      position factory: :qb
    end
  end
end
