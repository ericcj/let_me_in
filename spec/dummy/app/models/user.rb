class User < OmniAuth::Identity::Models::ActiveRecord
  include LetMeIn::LinkedAccounts::Identity
end
