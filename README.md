# MyApp

Add this to your `/etc/hosts` file:

```
127.0.0.1	repro.local
127.0.0.1	demo.repro.local
```

## Steps to reproduce

1. Start the server with `mix phx.server`
2. Visit `http://repro.local:4000/` in your browser
3. Create a new demo organization with any email
4. You should be redirected to the mailbox
5. Click on the link in the email
6. You should be redirected and authenticated to `http://demo.repro.local:4000/`
7. Click on the `Sign-out` button
8. Sign in to `http://demo.repro.local:4000/sign-in` using magic link and the same email used before
9. You should receive an error "Invalid password", and the following error in the logs:

```elixir
[error] Failed to generate token for MyApp.Accounts.User: %Ash.Error.Invalid{
  bread_crumbs: ["Error returned from: MyApp.Accounts.Token.store_token"],
  changeset: "#Changeset<>",
  errors: [
    %Ash.Error.Invalid.TenantRequired{
      resource: MyApp.Accounts.Token,
      splode: Ash.Error,
      bread_crumbs: ["Error returned from: MyApp.Accounts.Token.store_token"],
      vars: [],
      path: [],
      stacktrace: #Splode.Stacktrace<>,
      class: :invalid
    }
  ]
}
```
