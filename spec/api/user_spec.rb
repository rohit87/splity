require "spec_helper"

describe "Users API" do

  describe "CRUD" do

    describe "The Create (PUT) API" do
      context "when the user is invalid" do
        it "Returns HTTP Status Code 400" do
          create_user FactoryGirl.build(:user, email: "")
          response_code.should eq 400
        end

        it "Returns an error message" do
          create_user FactoryGirl.build(:user, email: "")
          json["err"].should_not be_nil
        end

        it "Returns an array of errors" do
          create_user FactoryGirl.build(:user, email: "")
          json["errors"].should be_a Array
        end
      end

      context "when the user is valid" do
        it "Returns HTTP Status Code 200" do
          send_valid_create_user_request
          response_code.should eq 200
        end

        it "Creates the user provided" do
          user = send_valid_create_user_request
          get_user_by_id json["user"]["id"]
          json["user"].should_not be_nil
        end

        it "Returns the created user" do
           user = send_valid_create_user_request
           json["user"]["id"].should_not be_nil
           user.email.should eq json["user"]["email"]
           user.name.should eq json["user"]["name"]
         end

        it "Does not return the users password" do
          user = send_valid_create_user_request
          get_user_by_id json["user"]["id"]
          json["user"]["password_digest"].should be_nil
        end
      end

      context "when the email has already been taken" do
        it "Returns HTTP Status Code 400" do
          u1 = FactoryGirl.create :user
          send_valid_create_user_request email: u1.email
          response_code.should eq 400
        end

        it "Returns an error message" do
          u1 = FactoryGirl.create :user
          send_valid_create_user_request email: u1.email
          json["err"].should_not be_nil
        end
      end

    end

    describe "The Retrieve (GET) API" do

      context "when user with given id is missing" do
        it "Returns HTTP Status Code 404" do
          user = get_user_by_id random_number
          response_code.should eq 404
        end

        it "Returns error message" do
          user = get_user_by_id (rand * 100000).to_i
          json["err"].should_not be_nil
        end
      end

      context "when user with given id is present" do
        it "Returns HTTP Status Code 200" do
          user = FactoryGirl.create :user
          get_user_by_id user.id
          response_code.should eq 200
        end

        it "Returns the requested user" do
          user = FactoryGirl.create :user
          get_user_by_id user.id
          user.id.should eq json["user"]["id"]
          user.email.should eq json["user"]["email"]
          user.name.should eq json["user"]["name"]
        end

        it "Does not return the user's password" do
          user = FactoryGirl.create :user
          get_user_by_id user.id
          json["user"]["password_digest"].should be_nil
        end
      end

    end

    describe "The Delete (DELETE) API" do

      context "when authorization token is missing from the headers" do
        it "returns HTTP Status Code 401" do
          user = FactoryGirl.create :user
          delete_user_by_id user.id
          expect(response_code).to eq 401
        end

        it "returns an error message" do
          user = FactoryGirl.create :user
          delete_user_by_id user.id
          expect(json["err"]).not_to eq nil
        end
      end

      context "when an incorrect user id is given and auth token is present and correct" do
        it "returns HTTP Status Code 401" do
          token = authenticate_user
          delete_user_by_id random_number, nil, { auth_token_header => token }
          expect(response_code).to eq 401
        end

        it "returns an error message" do
          delete_user_by_id random_number
          expect(json["err"]).not_to eq nil
        end
      end

      context "when user id is present and correct and authorization token is someone elses" do
        it "returns HTTP Status Code 401" do
          user1, user2 = FactoryGirl.create(:user), FactoryGirl.create(:user)
          token1 = authenticate_user(user1)
          delete_user_by_id user2.id, nil, { auth_token_header => token1 }
          expect(response_code).to eq 401
        end
        it "returns an error message" do
          user1, user2 = FactoryGirl.create(:user), FactoryGirl.create(:user)
          token1 = authenticate_user(user1)
          delete_user_by_id user2.id, nil, { auth_token_header => token1 }
          expect(json["err"]).not_to be_nil
        end
      end

      context "when user id is present and correct and auth token is present and correct and is of same user" do
        it "returns HTTP Status Code 200" do
          user = FactoryGirl.create :user
          token = authenticate_user user
          delete_user_by_id user.id, nil, { auth_token_header => token }
          expect(response_code).to eq 200
        end
        it "returns response with err as nil" do
          user = FactoryGirl.create :user
          token = authenticate_user user
          delete_user_by_id user.id, nil, { auth_token_header => token }
          expect(json["err"]).to be_nil
        end
        it "deletes the user" do
          user = FactoryGirl.create :user
          token = authenticate_user user
          delete_user_by_id user.id, nil, { auth_token_header => token }
          token = authenticate_user user
          expect(response_code).to eq 401
        end
      end

    end

    describe "The Update (POST) API" do

      context "when authorization token is missing" do
        it "returns HTTP Status Code 401" do
          update_user FactoryGirl.create(:user).id, {}
          expect(response_code).to eq 401
        end

        it "returns an error message" do
          update_user FactoryGirl.create(:user).id, {}
          expect(json["err"]).not_to be_nil
        end
      end

      context "when user id is invalid" do
        it "returns HTTP Status Code 401" do
          update_user random_number
          expect(response_code).to eq 401
        end
        it "returns an error message" do
          update_user random_number
          expect(json["err"]).not_to be_nil
        end
      end

      context "when authorization token is correct and user id is someone elses" do
        it "returns HTTP Status Code 401" do
          user1, user2 = FactoryGirl.create(:user), FactoryGirl.create(:user)
          token1 = authenticate_user user1
          update_user user2.id, {}, { auth_token_header => token1 }
          expect(response_code).to eq 401
        end
        it "returns an error message" do
          user1, user2 = FactoryGirl.create(:user), FactoryGirl.create(:user)
          token1 = authenticate_user user1
          update_user user2.id, {}, { auth_token_header => token1 }
          expect(json["err"]).not_to be_nil
        end
      end

      context "when authorization token is correct and user id is correct" do
        context "when no attributes are passed" do
          it "returns HTTP Status Code 400" do
            user = FactoryGirl.create(:user)
            token = authenticate_user user
            update_user user, nil, { auth_token_header => token }
            expect(response_code).to eq 400
          end
          it "returns an error message" do
            user = FactoryGirl.create(:user)
            token = authenticate_user user
            update_user user, nil, { auth_token_header => token }
            expect(json["err"]).not_to be_nil
          end
        end
        context "when attributes are passed" do
          before {
            @user = FactoryGirl.create(:user)
            @token = authenticate_user @user
          }
          it "returns HTTP Status Code 400 if attributes is an array" do
            update_user @user, [], { auth_token_header => @token }
            expect(response_code).to eq 400
          end

        end
      end

    end

  end

end