class Rental < ApplicationRecord
  belongs_to :user
  belongs_to :movie
  validate :not_currently_rented
  validates :valid_to, presence: true
  validates :valid_from, presence: true
  scope :active, -> {where("valid_from < ? AND valid_to > ?", Time.current, Time.current)}

 def not_currently_rented
  errors.add(:rental, "You already have an active rental for this Movie") if currently_rented?
 end

 def currently_rented?
  Rental.active.where(user: user, movie: movie).count > 0
 end

end
