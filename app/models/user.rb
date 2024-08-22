class User < ApplicationRecord
  has_secure_password

  # Custom authentication method
  def self.authenticate_by(email:, password:)
    user = find_by(email: email)
    user if user&.authenticate(password)
  end

  has_many :sessions, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 12 }, allow_nil: true

  # Normalizing email before saving
  before_save :normalize_email

  private

  def normalize_email
    self.email = email.strip.downcase
  end
end
