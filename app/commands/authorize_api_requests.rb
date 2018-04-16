class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user
  end

  private

  attr_reader :headers

  # Will return user if decoded_auth_token decodes a valid token.
  # Then we return @user, otherwise, we return a error.
  def user
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
    @user || errors.add(:token, 'Invalid Token') && nil
  end

  # Decodes the token received from http_auth_header.
  # It then, sets the user_id to the @decoded_auth_token from our JsonWebToken Service Object.
  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  # Extract token from the authorization header received when headers initialized.
  def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    else
      errors.add(:token, 'Missing Token')
    end
    nil
  end
end
