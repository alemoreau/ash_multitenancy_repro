defmodule MyApp.Accounts.Checks.InitialAccountCreation do
  use Ash.Policy.SimpleCheck

  @impl Ash.Policy.Check
  def describe(_) do
    "Initial account is created automatically"
  end

  @impl Ash.Policy.SimpleCheck
  def match?(_, %{subject: %{context: %{private: %{initial_account?: true}}}}, _), do: true

  def match?(_, _, _), do: false
end
