# class Ability 
#   include CanCan::Ability
#   
#   def initialize(user)
#     user ||= User.new # assign as guest user, if no user assigned
#     can :manage, :all
#   end
# end