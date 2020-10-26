defmodule Bff do
  @moduledoc """
  Bff keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def register_user_command(user_id, trace_id, attrs) do
    id = Ecto.UUID.generate()
    attrs = Map.put(attrs, "id", id)
    case Identity.validate_user(attrs) do
      {:ok, _} ->
        %{
          "stream_name" => "identity:command-#{id}",
          "type" => "Register",
          "data" => attrs,
          "metadata" => %{
            "trace_id" => trace_id,
            "user_id" => user_id
          }
        }
        |> EventStore.Core.create_event()
      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
