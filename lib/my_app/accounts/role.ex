defmodule MyApp.Accounts.Role do
  use Ash.Type.Enum, values: [:admin, :user]
end
