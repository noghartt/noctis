defmodule Noctis.Repo.Migrations.CreateUserTransactions do
  use Ecto.Migration

  def change do
    create table(:user_transactions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :receiver_id, references :users
      add :sender_id, references :users
      add :transaction_id, references :transactions

      timestamps()
    end

    create unique_index :user_transactions, [:transaction_id]
  end
end
