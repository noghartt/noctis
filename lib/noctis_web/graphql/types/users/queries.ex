defmodule NoctisWeb.GraphQL.Queries.User do
  use Absinthe.Schema.Notation

  object :user_queries do
    @desc "Get all users, optionally filtering"
    field :users, list_of(:user)  do
      resolve fn _, _ ->  {:ok, %{id: 1, name: "John Doe"}} end
    end

    @desc "Get a user using criteria"
    field :user, :user do
      resolve fn _, _ ->  {:ok, %{id: 1, name: "John Doe"}} end
    end
  end
end
