class User < ActiveRecord::Base
  has_and_belongs_to_many :projects

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def all_projects
    projects + Project.where(owner: self)
  end
end
