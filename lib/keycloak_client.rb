# frozen_string_literal: true

class KeycloakClient

  def user_pk_secret(secret: nil)
    pk_secret_base = secret || Keycloak::Client.get_attribute('pk_secret_base')
    return if pk_secret_base.nil?

    Digest::SHA512.hexdigest(secret_key_base + pk_secret_base)
  end

  def find_or_create_pk_secret_base
    Keycloak::Client.get_attribute('pk_secret_base') || create_pk_secret_base
  end

  private

  def create_pk_secret_base
    user_id = Keycloak::Client.get_attribute('sub')
    pk_secret_base = SecureRandom.base64(32)
    token = JSON.parse(Keycloak::Client.get_token_by_client_credentials)['access_token']
    user_attributes = JSON.parse(Keycloak::Admin.get_user(user_id, token))['attributes'] || {}
    user_attributes['pk_secret_base'] = pk_secret_base
    Keycloak::Admin.update_user(user_id, { attributes: user_attributes }, token)
    pk_secret_base
  end

  def secret_key_base
    Rails.application.secrets.secret_key_base
  end

end
