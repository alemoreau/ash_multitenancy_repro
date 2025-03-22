defmodule MyApp.Accounts do
  use Ash.Domain,
    otp_app: :my_app,
    extensions: [AshPhoenix]

  resources do
    resource MyApp.Accounts.Token

    resource MyApp.Accounts.User do
      define :create_admin, action: :create_admin
      define :request_magic_link, action: :request_magic_link
    end

    resource MyApp.Accounts.Organization do
      define :create_organization, action: :create
      define :create_organization_with_initial_account, action: :create_with_initial_account
      define :get_organization_by_subdomain, args: [:subdomain], action: :get_by_subdomain
    end
  end
end
