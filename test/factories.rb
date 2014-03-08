
# @author Alexander Clelland

FactoryGirl.define do

  factory :user, class: User do
    full_name "#{Random.firstname} #{Random.lastname}"
    email Random.email
    affiliation Random.alphanumeric
    password Random.alphanumeric
  end

end
