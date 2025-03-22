defmodule MyAppWeb.Live.Home do
  use MyAppWeb, :live_view

  def render(assigns) do
    ~H"""
    <.form for={@form} phx-change="validate" phx-submit="submit">
      <div>
        <div>
          <.input type="text" field={@form[:email]} placeholder="Email" />
          <.input type="text" field={@form[:name]} placeholder="Company" />
        </div>
        <div>
          <.button type="submit">
            <span>Create organization</span>
          </.button>
        </div>
      </div>
    </.form>
    """
  end

  def mount(_params, _session, socket) do
    # Here we call our new generated function to create the form
    {:ok,
     assign(socket,
       form: MyApp.Accounts.form_to_create_organization_with_initial_account() |> to_form()
     )}
  end

  def handle_event("validate", %{"form" => params}, socket) do
    form = AshPhoenix.Form.validate(socket.assigns.form, params)
    {:noreply, assign(socket, :form, form)}
  end

  def handle_event("submit", %{"form" => params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: params) do
      {:ok, _user} ->
        socket =
          socket
          |> put_flash(:success, "Organization created successfully")
          |> push_navigate(to: ~p"/dev/mailbox")

        {:noreply, socket}

      {:error, form} ->
        socket =
          socket
          |> put_flash(:error, "Something went wrong")
          |> assign(:form, form)

        {:noreply, socket}
    end
  end
end
