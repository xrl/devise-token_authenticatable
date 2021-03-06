class User < ActiveRecord::Base
  devise  :database_authenticatable, :confirmable, :lockable, :recoverable,
          :registerable, :rememberable, :timeoutable, :token_authenticatable,
          :trackable, :validatable, :omniauthable

  attr_accessor :other_key

  def raw_confirmation_token
    @raw_confirmation_token
  end

  module ExtendMethods
    def new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.facebook_data"]
          user.email = data["email"]
          user.confirmed_at = Time.now
        end
      end
    end
  end

  # They need to be included after Devise is called.
  extend ExtendMethods
end
