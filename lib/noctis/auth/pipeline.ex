defmodule Noctis.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :noctis,
    module: Noctis.Guardian,
    error_handler: Noctis.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader,
    claims: %{"typ" => "access"},
    scheme: "Bearer"
  plug Guardian.Plug.LoadResource, allow_blank: true
end
