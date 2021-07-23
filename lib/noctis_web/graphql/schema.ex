defmodule NoctisWeb.GraphQL.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema

  import_types NoctisWeb.GraphQL.Types.Queries.{User}

  import_types NoctisWeb.GraphQL.Types.Mutations.User

  query do
    import_fields :user_queries
  end

  mutation do
    import_fields :user_mutations
  end

end
