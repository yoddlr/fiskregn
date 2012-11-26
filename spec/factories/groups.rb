# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group do
   sequence :name do
     "#{Faker::Name.first_name}'s group" 
   end
   members {|members| [members.association(:user)]}
   admins {|admins| [admins.association(:user)]}
  end
end
