defmodule NoctisWeb.GraphQL.Mutations.Transaction do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias NoctisWeb.Resolvers.Transaction

  object :transaction_mutations do
    field :create_transaction, type: :boolean do
      @desc "ID of user that you want to receive that transaction"
      arg :receiver_id, non_null(:id)

      @desc "Quantity of money that you want to transfer, in cents"
      arg :amount, non_null(:string)

      resolve &Transaction.create/3
    end

    field :refund_transaction, type: :boolean do
      @desc "ID of a transaction that you want to refund"
      arg :transaction, non_null(:id)

      resolve &Transaction.refund/3
    end
  end
end
