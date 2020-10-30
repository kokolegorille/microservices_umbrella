defmodule VideoStore.Factory do
  @moduledoc """
  Ex Machina factories module
  """
  use ExMachina.Ecto, repo: VideoStore.Repo

  # alias VideoStore.Core.Video

  # def video_factory do
  #   %Video{
  #     name: sequence(:name, &"name-#{&1}"),
  #     email: sequence(:email, &"email-#{&1}@example.com"),
  #     password_hash: User.encrypt_password("secret")
  #   }
  # end
end
