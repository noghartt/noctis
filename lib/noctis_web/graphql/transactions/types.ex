defmodule NoctisWeb.GraphQL.Types.Transaction do
  use Absinthe.Schema.Notation

  object :transactions do
    field :id, non_null(:id)
    field :amount, :integer
    field :refund, :boolean
    field :receiver_id, :id
  end
end
