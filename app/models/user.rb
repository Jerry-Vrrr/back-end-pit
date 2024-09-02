class User < ApplicationRecord
  has_secure_password

  # Associations
  has_many :sessions, dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 12 }, allow_nil: true
  validates :role, presence: true, inclusion: { in: %w[admin client] } # Assuming 'admin' and 'client' are the two roles
  validates :logged_company_id, numericality: { only_integer: true }, allow_nil: true

  # Callbacks
  before_save :normalize_email

  # Custom authentication method
  def self.authenticate_by(email:, password:)
    user = find_by(email: email)
    user if user&.authenticate(password)
  end

  private

  def normalize_email
    self.email = email.strip.downcase
  end
end
