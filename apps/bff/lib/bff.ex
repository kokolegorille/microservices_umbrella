defmodule Bff do
  @moduledoc """
  Bff keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def register_user_command(user_id, trace_id, attrs) do
    %{
      "stream_name" => "identity:command-#{user_id}",
      "type" => "Register",
      "data" => attrs,
      "metadata" => %{
        "trace_id" => trace_id,
        "user_id" => user_id
      }
    }
    |> EventStore.Core.create_event
  end
end
