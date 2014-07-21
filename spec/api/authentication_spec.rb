require "spec_helper"

describe "Authentication API" do

  describe "Login (/login) API" do

    it "Returns HTTP Status 404 for GET requests" do
      get(api_authentication_login_path)
      response_code.should eq 404
    end

    it "Returns HTTP Status 400 if email and password are not provided" do
      post api_authentication_login_path, { }
      response_code.should eq 400
    end

    it "Returns an error message if email and password are not provided" do
      post api_authentication_login_path, {}
      json["err"].should_not be_nil
    end

    it "Returns HTTP Status 400 if anything apart from email and password is provided" do
      post api_authentication_login_path, { email: "", password: "", rubbish: "" }
      response_code.should eq 400
    end

    it "Returns an error message if anything apart from email and password is provided" do
      post api_authentication_login_path, { email: "", password: "", rubbish: "" }
      json["err"].should_not be_nil
    end

    it "Returns HTTP Status 401 when incorrect email and password are provided" do
      post api_authentication_login_path, { email: "a@b.com", password: "password" }
      response_code.should eq 401
    end

    it "Returns an error message when incorrect email and password are provided" do
      post api_authentication_login_path, { email: "a@b.com", password: "password" }
      json["err"].should_not be_nil
    end

    it "Returns HTTP Status 200 when correct email and password are provided" do
      user = FactoryGirl.create(:user)
      post api_authentication_login_path, { email: user.email, password: user.password }
      response_code.should eq 200
    end

    it "Returns an access token when correct email and password are provided" do
      user = FactoryGirl.create(:user)
      post api_authentication_login_path, { email: user.email, password: user.password }
      json["access_token"].should_not be_nil
    end

    it "Returns the correct user when correct email and password are provided" do
      user = FactoryGirl.create(:user)
      post api_authentication_login_path, { email: user.email, password: user.password }
      json["user"]["email"].should eq user.email
      json["user"]["name"].should eq user.name
    end

    it "Does not return the user's password along with the fields of the user after login" do
      user = FactoryGirl.create(:user)
      post api_authentication_login_path, { email: user.email, password: user.password }
      json["user"]["password_digest"].should be_nil
    end

    it "Returns HTTP Status 400 if token is present under correct header and login is requested" do
      user = FactoryGirl.create(:user)
      post api_authentication_login_path, { email: user.email, password: user.password }
      access_token = json["access_token"]
      post api_authentication_login_path, { email: user.email, password: user.password }, { auth_token_header => access_token }
      response_code.should eq 400
    end
  end

  describe "Current User (/me) API" do
    it "Returns HTTP Status 404 for POST requests" do
      post api_authentication_me_path
      response_code.should eq 404
    end

    it "Returns the logged in user when correct token is provided" do
      user = FactoryGirl.create :user
      post api_authentication_login_path, { email: user.email, password: user.password }
      get api_authentication_me_path, nil, { auth_token_header => json["access_token"] }
      json["user"]["name"].should eq user.name
    end

    it "Does not return the logged in user's password" do
      user = FactoryGirl.create :user
      post api_authentication_login_path, { email: user.email, password: user.password }
      get api_authentication_me_path, nil, { auth_token_header => json["access_token"] }
      json["user"]["password_digest"].should be_nil
    end

    it "Returns HTTP Status 400 when correct token is provided under incorrect HTTP header" do
      user = FactoryGirl.create :user
      post api_authentication_login_path, { email: user.email, password: user.password }
      get api_authentication_me_path, nil, { "X-Authorization-Token-Rubbish" => json["access_token"] }
      response_code.should eq 400
    end

    it "Returns HTTP Status 401 when incorrect token is provided" do
      get api_authentication_me_path, nil, { auth_token_header => "abcdefghijklmnopqrstuvwxyz" }
      response_code.should eq 401
    end

    it "Returns HTTP Status 401 when expired token is provided" do
      user = FactoryGirl.create :user
      post api_authentication_login_path, { email: user.email, password: user.password }
      token = json["access_token"]
      post api_authentication_logout_path, nil, { auth_token_header => token }
      get api_authentication_me_path, nil, { auth_token_header => token }
      response_code.should eq 401
    end

    it "Returns HTTP Status 401 when no token is provided under any header" do
      get api_authentication_me_path
      response_code.should eq 400
    end

  end

  describe "Logout (/logout) API" do
    it "Returns HTTP Status 404 for GET requests" do
      get api_authentication_logout_path
      response_code.should eq 404
    end

    it "Returns HTTP Status 401 when incorrect token is provided" do
      post api_authentication_logout_path, nil, { auth_token_header => '123' }
      response_code.should eq 401
    end

    it "Returns error message when incorrect token is provided" do
      post api_authentication_logout_path, nil, { auth_token_header => '123' }
      json["err"].should_not be_nil
    end

    it "Returns HTTP Status 400 when correct token is provided under incorrect HTTP header" do
      post api_authentication_logout_path, nil, { 'X-Authorization-Token-Rubbish' => '123' }
      response_code.should eq 400
    end

    it "Returns HTTP Status 200 when correct token is provided" do
      user = FactoryGirl.create :user
      post api_authentication_login_path, { email: user.email, password: user.password }
      post api_authentication_logout_path, nil, { auth_token_header => json["access_token"] }
      response_code.should eq 200
    end

    it "Invalidates the token provided if the token is correct" do
      user = FactoryGirl.create :user
      post api_authentication_login_path, { email: user.email, password: user.password }
      token = json["access_token"]
      post api_authentication_logout_path, nil, { auth_token_header => token }
      response_code.should eq 200
      post api_authentication_logout_path, nil, { auth_token_header => token }
      response_code.should eq 401
    end
  end

end