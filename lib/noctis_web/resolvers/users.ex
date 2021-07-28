defmodule NoctisWeb.Resolvers.User do
  alias Noctis.Users

  def create_user(_root, args, _resolution) do
    args
    |> Users.create()
    |> case do
      {:ok, user} ->
        {:ok, user}
      {:error, changeset} ->
        {:error, format_error(changeset)}
    end
  end

  def login(_root, %{email: email, password: password}, _resolution) do
    case Users.authenticate(email, password) do
      {:ok, token, _full_claims} ->
        {:ok, token}
      {:error, _} ->
        {:error, [message: "Your email or password is wrong. Please, try again."]}
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
