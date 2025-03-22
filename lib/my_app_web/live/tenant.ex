defmodule MyAppWeb.Live.Tenant do
  use MyAppWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1>logged in ! {@current_user.email}</h1>
      <p>Now sign-out and try to login again with magic-link</p>
      <a href="/sign-out" class="rounded-lg bg-zinc-100 px-2 py-1 hover:bg-zinc-200/80">
        Sign-out
      </a>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
