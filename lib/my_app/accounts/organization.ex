defmodule MyApp.Accounts.Organization do
  use Ash.Resource,
    otp_app: :my_app,
    domain: MyApp.Accounts,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshSlug]

  postgres do
    table "organizations"
    repo MyApp.Repo

    manage_tenant do
      template ["org_", :subdomain]
      create? true
      update? false
    end
  end

  actions do
    defaults [:read, :destroy, update: [:name]]

    read :get_by_subdomain do
      get_by :subdomain
    end

    create :create do
      primary? true
      accept [:name]

      change slugify(:name, into: :subdomain)
    end

    create :create_with_initial_account do
      accept [:name]
      argument :email, :string

      change slugify(:name, into: :subdomain)

      change after_action(fn changeset, organization, _context ->
               %{email: email} = changeset.arguments
               context = %{private: %{initial_account?: true}}

               with {:ok, _admin} <-
                      MyApp.Accounts.create_admin(
                        %{
                          email: email
                        },
                        tenant: organization,
                        context: context
                      ),
                    :ok <-
                      MyApp.Accounts.request_magic_link(%{email: email},
                        tenant: organization,
                        authorize?: false
                      ) do
                 {:ok, organization}
               else
                 {:error, _reason} ->
                   {:error, "Failed to create admin"}
               end
             end)
    end
  end

  multitenancy do
    strategy :attribute
    attribute :subdomain
    global? true
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      public? true
      allow_nil? false
    end

    attribute :subdomain, :ci_string do
      public? true
      allow_nil? false
    end

    timestamps()
  end

  identities do
    identity :subdomain, [:subdomain], all_tenants?: true
  end

  defimpl Ash.ToTenant do
    def to_tenant(%{subdomain: subdomain}, resource) do
      if Ash.Resource.Info.data_layer(resource) == AshPostgres.DataLayer &&
           Ash.Resource.Info.multitenancy_strategy(resource) == :context do
        "org_#{subdomain}"
      else
        subdomain
      end
    end
  end
end
