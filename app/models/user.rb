class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 90 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with:   VALID_EMAIL_REGEX }
  #'uniqueness: true' evita que haya emails repetidos; 'presence: true' impide que se generen usuarios sin email
  validates :password, presence: true, length: { minimum: 8 }
  has_secure_password
  has_many :rentals
  has_many :movies, through: :rentals

  def is_admin?
    self.admin
  end

 end