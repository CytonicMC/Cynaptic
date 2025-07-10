class ApiKey < ApplicationRecord
  HMAC_SECRET_KEY = Rails.application.credentials.hmac_key

  before_create :generate_token
  before_create :generate_digest

  attr_accessor :raw_token

  def self.find_by_token!(token)
    find_by!(digest: generate_digest(token))
  end

  def self.find_by_token(token)
    find_by(digest: generate_digest(token))
  end

  def self.generate_digest(token)
    OpenSSL::HMAC.hexdigest("SHA256", HMAC_SECRET_KEY, token)
  end

  def self.find(owner)
    find_by(owner: owner)
  end

  private

  def generate_token
    self.raw_token = SecureRandom.base58(32)
  end

  def generate_digest
    self.digest = self.class.generate_digest(self.raw_token)
  end
end
