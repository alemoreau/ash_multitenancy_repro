defmodule MyAppWeb.Tenant.Plug do
  @moduledoc """
  Set Ash tenant from current_tenant in connection
  """
  @behaviour Plug

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, opts) do
    with subdomain when not is_nil(subdomain) <- conn.assigns.current_subdomain,
         {:ok, organization} <- MyApp.Accounts.get_organization_by_subdomain(subdomain) do
      conn
      |> Ash.PlugHelpers.set_tenant(organization)
      |> Plug.Conn.assign(:current_tenant, organization)
      |> MyAppWeb.Tenant.Router.call(opts)
    else
      _ ->
        conn |> MyAppWeb.Router.call(opts)
    end
  end
end
