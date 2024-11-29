class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  geocoded_by :full_address
  after_validation :geocode, if: :will_save_change_to_address?
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :events
  has_many :members
  has_many :groups, through: :members
  has_many :votes
  has_many :movie_comments
  has_one_attached :profile_picture

  def full_address
    "#{self.address}, #{self.zipcode} #{self.city}"
  end

  private

  # Vérifie si une des colonnes d'adresse a changé
  def will_save_change_to_address_components?
    will_save_change_to_address? || will_save_change_to_zipcode? || will_save_change_to_city?
  end
end
