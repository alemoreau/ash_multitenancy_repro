defmodule MyApp.Accounts.User.Senders.SendMagicLinkEmail do
  @moduledoc """
  Sends a magic link email
  """

  use AshAuthentication.Sender
  use MyAppWeb, :verified_routes

  import Swoosh.Email
  alias MyApp.Mailer

  @impl true
  def send(user_or_email, token, opts) do
    # if you get a user, its for a user that already exists.
    # if you get an email, then the user does not yet exist.

    tenant = Keyword.fetch!(opts, :tenant)

    email =
      case user_or_email do
        %{email: email} -> email
        email -> email
      end

    new()
    |> from({"noreply", "noreply@example.com"})
    |> to(to_string(email))
    |> subject("Your login link")
    |> html_body(body(token: token, email: email, tenant: tenant))
    |> Mailer.deliver!()
  end

  defp body(params) do
    tenant = params[:tenant]

    %{
      host: host
    } = uri = url(~p"/auth/user/magic_link/?token=#{params[:token]}") |> URI.parse()

    url = %{uri | host: to_string(tenant.subdomain) <> "." <> host} |> to_string()

    """
    <p>Hello, #{params[:email]}! Click this link to sign in:</p>
    <p><a href="#{url}">#{url}</a></p>
    """
  end
end
