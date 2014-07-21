module Requests

  def auth_token_header
    "X-Authorization-Token"
  end

  def random_number
    (rand * 100000).to_i
  end

  module JsonHelpers
    
    def json
      @json = JSON.parse(response.body)
    end

    def response_code
      @response_code = response.code.to_i
    end
  end

  module AuthHelpers

    def authenticate_user(user=FactoryGirl.create(:user))
      post api_authentication_login_path, { email: user.email, password: user.password }
      json["access_token"]
    end

  end

  module UserHelpers

    def get_user_by_id(id)
      get api_users_get_path id
    end

    def create_user(user)
      put api_users_create_path, { user: user }.to_json
    end

    def send_valid_create_user_request(overrides={})
      user = FactoryGirl.build :user
      password = user.password
      user_hash = user.serializable_hash
      user_hash.merge!(password: password).merge! overrides
      create_user user_hash
      return user
    end

    def delete_user_by_id(id, data=nil, headers=nil)
      delete api_users_delete_path id, data, headers
    end

    def update_user(user_id, attributes_to_update=nil, headers={})
      post api_users_update_path(user_id), {attributes: attributes_to_update}.to_json, headers
    end

  end
end