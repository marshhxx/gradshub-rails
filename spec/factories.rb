FactoryGirl.define do
  factory :user do
    uid      "unique"
    name     "Michael"
    lastname "Hart"
    email    "michael@example.com"
    password "12345678"
    auth_token "token"
  end

  factory :martin, class: User do
    uid      "uu"
    name     "Martin"
    lastname "Bomio"
    email    "martin@example.com"
    password "12345678"
    auth_token "token"
  end
end