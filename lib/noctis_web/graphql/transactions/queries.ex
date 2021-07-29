defmodule NoctisWeb.GraphQL.Queries.Transaction do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias NoctisWeb.Resolvers.Transaction

  object :transaction_queries do
    field :get_transactions, type: list_of(:transactions) do
      @desc "Initial date of range formatted as ISO8601"
      arg :initial_date, :naive_datetime

      @desc "End date of range formatted as ISO8601"
      arg :end_date, :naive_datetime

      resolve &Transaction.get_transactions/3
    end
  end
end
