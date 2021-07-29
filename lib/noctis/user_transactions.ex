defmodule Noctis.UserTransactions do
  import Ecto.Changeset

  use Noctis.Schema

  alias Noctis.{Users, Transactions, Repo}

  @required_fields ~w(sender_id receiver_id transaction_id)a

  schema "user_transactions" do
    belongs_to :sender, Users
    belongs_to :receiver, Users
    belongs_to :transaction, Transactions

    timestamps()
  end

  def create(%{transaction: transaction, info: info}) do
    {:ok, %{id: transaction_id}} = Transactions.create(transaction)

    user_transactions_args = Map.put(info, :transaction_id, transaction_id)

    %__MODULE__{}
    |> changeset(user_transactions_args)
    |> Repo.insert()
  end

  @doc false
  def changeset(%__MODULE__{} = user_transactions, attrs) do
    user_transactions
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
