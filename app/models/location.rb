class Location < ActiveRecord::Base

  belongs_to :owner, polymorphic: true
  has_and_belongs_to_many :contents

  # A Publisher is a user that can publish content to this location
  has_and_belongs_to_many :publishers,
    join_table: "locations_publishers",
    foreign_key: "location_id",
    association_foreign_key: "publisher_id",
    class_name: "User"

  # A Publish_group is a group whose members can publish content to this location
  has_and_belongs_to_many :publish_groups,
    join_table: "locs_pub_groups",
    foreign_key: "location_id",
    association_foreign_key: "publish_group_id",
    class_name: "Group"

end
