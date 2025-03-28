defmodule MyApp.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], MyApp.Accounts.User, _opts) do
    Application.fetch_env(:my_app, :token_signing_secret)
  end
end
