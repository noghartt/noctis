defmodule NoctisWeb.GraphQL.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  import_types Absinthe.Type.Custom

  import_types NoctisWeb.GraphQL.Types.User
  import_types NoctisWeb.GraphQL.Mutations.User

  import_types NoctisWeb.GraphQL.Types.Transaction
  import_types NoctisWeb.GraphQL.Mutations.Transaction
  import_types NoctisWeb.GraphQL.Queries.Transaction

  query do
    import_fields :transaction_queries
  end

  mutation do
    import_fields :user_mutations
    import_fields :transaction_mutations
  end
end
