class User < ApplicationRecord
  has_many :projects, dependent: :destroy
  has_many :tasks, through: :projects

  normalizes :first_name, with: ->(first_name) { first_name.strip.titleize }
  normalizes :last_name, with: ->(last_name) { last_name.strip.titleize }
  normalizes :email, with: ->(email) { email.strip.downcase }

  has_secure_password

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :first_name, :last_name,
            presence: true

  validates :password,
            allow_nil: true,
            presence: true,
            length: { minimum: 6 }
end
