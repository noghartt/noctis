defmodule NoctisWeb.Resolvers.Transaction do
  import Ecto.Query, only: [where: 2, from: 2]
  import Ecto.Changeset, only: [change: 2]

  alias Noctis.{Users, UserTransactions, Repo, Transactions}

  def create(
    _root,
    %{amount: amount, receiver_id: receiver_id},
    %{context: %{current_user: current_user}}
  ) do
    amount_as_integer = String.to_integer(amount)

    cond do
      receiver_id == current_user.id ->
        {:error, "You cannot send a transaction to yourself"}
      amount_as_integer >= current_user.wallet ->
        {:error, "Your wallet has insufficient amount of money"}
      true ->
        updated_user = Ecto.Changeset.change(
          current_user,
          wallet: current_user.wallet - amount_as_integer
        )

        updated_receiver_user = Users
          |> where(id: ^receiver_id)
          |> Repo.one()
          |> (fn receiver_user -> Ecto.Changeset.change(
              receiver_user,
              wallet: receiver_user.wallet + amount_as_integer
          ) end).()

        Repo.transaction(fn ->
          Repo.update!(updated_user)
          Repo.update!(updated_receiver_user)
        end)

        transactions_args = %{
          transaction: %{refund: false, amount: amount_as_integer},
          info: %{sender_id: current_user.id, receiver_id: receiver_id}
        }

        case UserTransactions.create(transactions_args) do
          {:ok, _} ->
            {:ok, true}
          {:error, _} ->
            {:error, "Fail to create a transaction"}
        end
    end
  end
  def create(_root, _args, _resolution), do: {:error, "Invalid authentication token"}

  def refund(
    _root,
    %{transaction: transaction_id},
    %{context: %{current_user: _current_user}}
  ) do
    transaction = Transactions
    |> where(id: ^transaction_id)
    |> Repo.one()


    cond do
      transaction == nil ->
        {:error, "There aren't any transactions with this ID. Please try again."}
      transaction.refund == true ->
        {:error, "This transaction has already been refunded."}
      transaction.refund == false ->
        UserTransactions
        |> where(transaction_id: ^transaction_id)
        |> Repo.one()
        |> case do
          nil ->
            {:error, "Failed to update a transaction. Please try again."}
          user_transaction ->
            sender_user_changeset =
              with user <- Repo.get_by!(Users, id: user_transaction.sender_id),
                do: change(user, wallet: user.wallet + transaction.amount)

            receiver_user_changeset =
              with user <- Repo.get_by!(Users, id: user_transaction.receiver_id),
                do: change(user, wallet: user.wallet - transaction.amount)

            transaction_changeset = change(transaction, refund: true)

            Repo.transaction(fn ->
              Repo.update!(sender_user_changeset)
              Repo.update!(receiver_user_changeset)
              Repo.update!(transaction_changeset)
            end)
            |> case do
              {:ok, _} ->
                {:ok, true}
              {:error, _} ->
                {:error, "Failed to update a transaction. Please try again."}
            end
        end
    end
  end
  def refund(_root, _args, _resolution), do: {:error, "Invalid authentication token"}

  def get_transactions(_root, args, %{context: %{current_user: current_user}}) do

    query = from t in UserTransactions,
      where: t.sender_id == ^current_user.id
        and t.inserted_at >= ^args.initial_date
        and t.inserted_at <= ^args.end_date

    transaction_ids = Repo.all(query) |> Enum.map(fn transaction ->
      transaction.transaction_id
    end)

    transactions = from(t in Transactions, where: t.id in ^transaction_ids)
      |> Repo.all()

    {:ok, transactions}
  end
  def get_transactions(_root, _args, _resolution), do: {:error, "Invalid authentication token"}
end
