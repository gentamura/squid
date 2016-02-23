class User < ApplicationRecord
  has_one :money_account, dependent: :destroy
  # has_many :money_transfers, foreign_key: "sender_id", dependent: :destroy
  has_many :money_senders, foreign_key: "sender_id", class_name: "MoneyTransfer", dependent: :destroy
  has_many :money_receivers, foreign_key: "receiver_id", class_name: "MoneyTransfer", dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, foreign_key: "friend_id", through: :friendships
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_token, nil)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
    create_money_account!
  end

  def send_activation_mail
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def friend(other_user)
    friendships.create(friend_id: other_user.id)
  end

  def unfriend(other_user)
    friends.find(other_user.id).destroy
  end

  def friend?(other_user)
    friends.include?(other_user)
  end

  private
    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
