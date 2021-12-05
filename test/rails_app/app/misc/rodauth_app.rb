class RodauthApp < Rodauth::Rails::App
  configure RodauthMain
  configure RodauthAdmin, :admin

  configure(:jwt) do
    enable :jwt, :create_account, :verify_account
    rails_controller { ActionController::API } if ::Rails.gem_version >= Gem::Version.new("5.0")
    only_json? true
    prefix "/jwt"
    jwt_secret "secret"
    account_status_column :status
  end

  configure(:json) do
    enable :json, :create_account, :verify_account
    rails_controller { ActionController::API } if ::Rails.gem_version >= Gem::Version.new("5.0")
    only_json? true
    prefix "/json"
    account_status_column :status
  end

  route do |r|
    rodauth.load_memory

    r.rodauth
    r.on("admin") { r.rodauth(:admin) }
    r.on("jwt") { r.rodauth(:jwt) }
    r.on("json") { r.rodauth(:json) }

    if r.path == rails_routes.auth1_path
      rodauth.require_authentication
    end
  end
end