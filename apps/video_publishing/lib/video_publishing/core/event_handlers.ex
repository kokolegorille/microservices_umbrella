defmodule VideoPublishing.Core.EventHandlers do
  require Logger

  alias VideoPublishing.Core

  def handle(%{type: "PublishVideo", data: data, metadata: metadata} = _command) do
    video_id = data["id"]

    Task.start(fn ->
      %{
        "stream_name" => "videoPublishing-#{video_id}",
        "type" => "VideoPublished",
        "data" => data,
        "metadata" => metadata
      }
      |> Core.create_event()
    end)

    # name = data["name"]

    # email = %{
    #   "id" => email_id,
    #   "from" => @system_sender,
    #   "to" => data["email"],
    #   "subject" => "Welcome",
    #   "text" => "Welcome #{name} !",
    #   "html" => "Welcome <strong>#{name} !</strong>"
    # }

    # email_id
    # |> Projection.load_email()
    # |> Projection.ensure_email_has_not_been_sent()
    # |> if do
    #   Task.start(fn ->
    #     %{
    #       "stream_name" => "sendEmail-#{email_id}",
    #       "type" => "EmailSent",
    #       "data" => email,
    #       "metadata" => metadata
    #     }
    #     |> Core.create_event()
    #   end)
    # else
    #   Logger.info("Email #{email_id} already sent")
    # end
  end

  def handle(command) do
    Logger.info("#{__MODULE__} Unknown Command #{inspect(command)}")
  end
end
