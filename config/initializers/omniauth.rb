OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider  :facebook, "696266227100703", "fc0db34bad4a189ee059ac79dc25f23c",
            {
              scope: 'email,user_friends',
              image_size: 'large'
            }
end