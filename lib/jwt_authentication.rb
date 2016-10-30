require "jwt"

class JwtAuthentication
  def self.encode(payload)
    expire_at = (DateTime.now + 5.hours).to_i
    expiration_payload = { data: payload, exp: expire_at }
    JWT.encode(expiration_payload, Rails.application.secrets.secret_key_base)
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base).
      first.with_indifferent_access
  rescue
    { error: "Invalid token" }
  end
end
