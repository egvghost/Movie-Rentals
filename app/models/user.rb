class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true #'uniqueness: true' evita que haya emails repetidos; 'presence: true' impide que se generen usuarios sin email
end
