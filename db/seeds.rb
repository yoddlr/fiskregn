# Setting up the public default group 'all', of which all users are members.
# Run like: rake db:seed

# Create group with illegal name

group = Group.new
group.name = '_omni'
group.save(validate: false)

User.all.each do |user|
  user.groups << group unless user.groups.exists?(group)
end
