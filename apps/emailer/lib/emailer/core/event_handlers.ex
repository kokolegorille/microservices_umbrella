defmodule Emailer.Core.EventHandlers do
  require Logger

  alias Emailer.{Core, Projection}

  @system_sender "admin@example.com"

  def handle(%{type: "SendEmail", data: data, metadata: metadata} = _command) do
    email_id = data["email_id"]
    name = data["name"]

    email = %{
      "id" => email_id,
      "from" => @system_sender,
      "to" => data["email"],
      "subject" => "Welcome",
      "text" => "Welcome #{name} !",
      "html" => "Welcome <strong>#{name} !</strong>"
    }

    email_id
    |> Projection.load_email()
    |> Projection.ensure_email_has_not_been_sent()
    |> if do
      Task.start(fn ->
        %{
          "stream_name" => "emailer-#{email_id}",
          "type" => "EmailSent",
          "data" => email,
          "metadata" => metadata
        }
        |> Core.create_event()
      end)
    else
      Logger.info("Email #{email_id} already sent")
    end
  end

  def handle(command) do
    Logger.info("#{__MODULE__} Unknown Command #{inspect(command)}")
  end
end
