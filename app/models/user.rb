class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :events
  has_many :members
  has_many :groups, through: :members
  has_many :votes
  has_one_attached :profile_picture

  def invited_events
    groups_ids = self.groups.ids
    invited_events = Event.where(group_id: self.groups.ids).where.not(user_id: self.id)
  end
end
