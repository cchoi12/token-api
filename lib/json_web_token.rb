# A singleton class restricts the instantiation of a class to a single object.
# We only need one object to do the JsonWebToken.
class JsonWebToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    def decode(token)
      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
end

# Two use cases:
# 1. For authenticating the user and generate a token for him/her using encode
# 2. To check if the user's token appended in each request is correct by using decode.
