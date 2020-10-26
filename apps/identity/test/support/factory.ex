defmodule Identity.Factory do
  @moduledoc """
  Ex Machina factories module
  """
  use ExMachina.Ecto, repo: Identity.Repo

  alias Identity.Core.User

  def user_factory do
    %User{
      name: sequence(:name, &"name-#{&1}"),
      email: sequence(:email, &"email-#{&1}@example.com"),
      password: "secret"
    }
  end
end
