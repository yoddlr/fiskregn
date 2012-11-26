# Setting up the public default group 'all', of which all users are members.
# Run like: rake db:seed
group = Group.create!(name: '_omni')
User.all.each do |user|
  user.groups << group
end