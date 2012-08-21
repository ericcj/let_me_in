module LetMeIn
  module LinkedAccounts
    module ParseAccount
      extend ActiveSupport::Concern


      module InstanceMethods

        def link(auth_hash, user)
          update_attributes({
            :user_id => user.id,
            :app_user_id => auth_hash[:uid],
            :app_username => auth_hash[:info][:username]
            # FIXME: :image_url => auth_hash[:info][:avatar]
          })
          self
        end

      end

      module ClassMethods

        def find_or_create_user_by_auth_hash(auth_hash, password)
          if account = find_by_app_user_id(auth_hash.uid, :include => :user)
            account.user
          else
            pf_user = auth_hash.info
            User.find_or_create_by_username(auth_hash.uid,
              :name => pf_user['username'], :email => pf_user['email'],
              :password => password, :password_confirmation => password)
          end
        end

        def link(auth_hash, user)
          account = self.find_or_create_by_user_id(:user_id => user.id)
          account.link(auth_hash, user)
        end

        def key
          ENV["PARSE_APPLICATION_ID"]
        end

        def secret
          ENV["PARSE_REST_API_KEY"]
        end
      end


    end
  end
end