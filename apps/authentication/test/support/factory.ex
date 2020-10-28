defmodule Authentication.Factory do
  @moduledoc """
  Ex Machina factories module
  """
  use ExMachina.Ecto, repo: Authentication.Repo

  alias Authentication.Core.User

  def user_factory do
    %User{
      name: sequence(:name, &"name-#{&1}"),
      email: sequence(:email, &"email-#{&1}@example.com"),
      password_hash: User.encrypt_password("secret")
    }
  end
end
