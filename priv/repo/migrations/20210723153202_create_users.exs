defmodule Noctis.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :cpf, :string, size: 11
      add :email, :string
      add :password, :string
      add :first_name, :string
      add :last_name, :string
      add :wallet, :bigint

      timestamps()
    end

    create unique_index :users, [:cpf]
    create unique_index :users, [:email]
  end

  def down do
    drop table(:users)
  end
end
