defmodule MyApp.Accounts.User.Senders.SendNewUserConfirmationEmail do
  @moduledoc """
  Sends an email for a new user to confirm their email address.
  """

  use AshAuthentication.Sender
  use MyAppWeb, :verified_routes

  import Swoosh.Email

  alias MyApp.Mailer

  @impl true
  def send(user, token, opts) do
    tenant = opts[:tenant]

    new()
    # TODO: Replace with your email
    |> from({"noreply", "noreply@example.com"})
    |> to(to_string(user.email))
    |> subject("Confirm your email address")
    |> html_body(body(token: token, tenant: tenant))
    |> Mailer.deliver!()
  end

  defp body(params) do
    token = params[:token]
    tenant = params[:tenant]

    %{
      host: host
    } = uri = url(~p"/auth/user/confirm_new_user?#{[confirm: token]}") |> URI.parse()

    url = %{uri | host: to_string(tenant.subdomain) <> "." <> host} |> to_string()

    """
    <p>Click this link to confirm your email:</p>
    <p><a href="#{url}">#{url}</a></p>
    """
  end
end
