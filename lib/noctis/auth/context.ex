defmodule Noctis.Auth.Context do
  @behaviour Plug

  import Plug.Conn

  alias Noctis.Guardian

  def init(opts), do: opts

  def call(conn, _opts) do
    case build_context(conn) do
      {:ok, context} ->
        put_private(conn, :absinthe, %{context: context})
      _ ->
        conn
    end
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
      {:ok, current_user} <- authenticate(token)
    do
      {:ok, %{current_user: current_user, token: token}}
    else
      _ ->
        {:error, "invalid_token"}
    end
  end

  defp authenticate(token) do
    with {:ok, claims} <- Guardian.decode_and_verify(token),
      {:ok, user} <- Guardian.resource_from_claims(claims)
    do
      {:ok, user}
    else
      {:error, :resource_not_found} ->
        {:error, "invalid_token"}
    end
  end
end
