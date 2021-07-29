defmodule Noctis.Transactions do
  use Noctis.Schema

  import Ecto.Changeset

  alias Noctis.Repo

  @required_field ~w(amount refund)a

  schema "transactions" do
    field :amount, :integer
    field :refund, :boolean

    timestamps()
  end

  def create(args) do
    %__MODULE__{}
    |> changeset(args)
    |> Repo.insert()
  end

  @doc false
  def changeset(%__MODULE__{} = user_transactions, attrs) do
    user_transactions
    |> cast(attrs, @required_field)
    |> validate_required(@required_field)
  end
end
