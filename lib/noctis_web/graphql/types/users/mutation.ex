defmodule NoctisWeb.GraphQL.Mutations.User do
  @moduledoc false

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias NoctisWeb.Resolvers.User

  object :user_mutations do
    field :create_user, type: :user do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      arg :first_name, non_null(:string)
      arg :last_name, :string
      arg :cpf, non_null(:string)

      resolve &User.create_user/3
    end
  end
end
