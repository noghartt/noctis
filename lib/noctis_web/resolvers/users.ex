defmodule NoctisWeb.Resolvers.User do
  alias Noctis.Users

  def create_user(_root, args, _resolution) do
    args
    |> Users.create
    |> case do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, format_error(changeset)}
    end
  end

  defp format_error(changeset) do
    changeset.errors
    |> Enum.map(fn {field, {error, _details}} ->
        [
          field: field,
          message: String.capitalize(error)
        ]
      end)
  end
end
