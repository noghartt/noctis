defmodule NoctisWeb.GraphQL.Types.User do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :email, :string
    field :cpf, :string
    field :first_name, :string
    field :last_name, :string
    field :wallet, :integer
  end
end
