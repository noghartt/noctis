defmodule NoctisWeb.GraphQL.Types.Mutations.User do
  @moduledoc false

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  input_object :user_input do
    field :name, non_null(:string)
  end

  object :user_mutations do

    @desc "Create or update an user"
    field :upsert_user, :user do
      arg :user, non_null(:user_input)

      resolve fn _, %{user: %{name: name}}, _ ->
        {:ok, %{id: 1, name: name }}
      end
    end

  end
end
