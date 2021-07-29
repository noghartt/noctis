defmodule Noctis.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :amount, :bigint
      add :refund, :boolean

      timestamps()
    end
  end
end
