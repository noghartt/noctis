defmodule Noctis.Users do
  @moduledoc false

  use Noctis.Schema

  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias Noctis.Repo

  @required_fields ~w(email password cpf first_name)a
  @optional_fields ~w(last_name wallet)a

  # Check if the password has at least: 8 characters, 1 uppercase letter,
  # 1 lowercase letter, 1 number and 1 special character
  @password_regex ~r/^(?:(?:(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]))|(?:(?=.*[a-z])(?=.*[A-Z])(?=.*[*.!@$%^&(){}[]:;<>,.?\/~_+-=|\]))|(?:(?=.*[0-9])(?=.*[A-Z])(?=.*[*.!@$%^&(){}[]:;<>,.?\/~_+-=|\]))|(?:(?=.*[0-9])(?=.*[a-z])(?=.*[*.!@$%^&(){}[]:;<>,.?\/~_+-=|\]))).{8,}$/

  schema "users" do
    field :email, :string
    field :password, :string
    field :cpf, :string
    field :first_name, :string
    field :last_name, :string
    field :wallet, :integer, default: 0

    timestamps()
  end

  def create(args) do
    %__MODULE__{}
    |> changeset(args)
    |> encrypt_password()
    |> Repo.insert_or_update()
  end

  def get_user!(id), do: Repo.get!(Noctis.Users, id)

  def authenticate(email, password) do
    query = from u in Noctis.Users, where: u.email == ^email

    case Repo.one(query) do
      nil ->
        Bcrypt.no_user_verify()
        {:error, :invalid_credentials}
      user ->
        if Bcrypt.verify_pass(password, user.password) do
          user
          |> Noctis.Guardian.encode_and_sign()
        else
          {:error, :invalid_credentials}
        end
    end
  end

  @doc false
  def changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(
        :first_name,
        min: 2,
        max: 15,
        message: "You need a minimum of 2 characters and a maximum of 15 characters."
      )
    |> validate_format(
        :cpf,
        ~r/[0-9]{9,11}$/,
        message: "You need to insert only number characters and between 9 and 11 characters."
      )
    # TODO: Improve this Email RegEx with RFC 5322
    |> validate_format(:email, ~r/@/)
    |> validate_format(
        :password,
        @password_regex,
        message: "You need at least 8 characters, 1 uppercase letter, 1 lowercase letter, 1 number and 1 special character"
      )
    |> unique_constraint(
      :email,
      message: "The e-mail used is already in use. Please, try again."
    )
    |> unique_constraint(
      :cpf,
      message: "The CPF used here is already in use. Please, try again."
    )
  end

  defp encrypt_password(%Ecto.Changeset{
      valid?: true,
      changes: %{password: password}
    } = changeset
  ) do
    change(changeset, password: Bcrypt.hash_pwd_salt(password))
  end
  defp encrypt_password(changeset), do: changeset
end
