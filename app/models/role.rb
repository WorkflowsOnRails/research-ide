# TODO
#
# @author Brendan MacDonell
class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource, polymorphic: true

  validates :name, presence: true
end
