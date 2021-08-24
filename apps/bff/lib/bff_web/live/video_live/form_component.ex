defmodule BffWeb.VideoLive.FormComponent do
  use BffWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, allow_upload(
      socket,
      :video,
      accept: ~w(.mp4),
      max_entries: 1,
      auto_upload: true,
      # Provide a limit, as the default is low
      max_file_size: 5_000_000_000,
    )}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true

  # Requested to get the progress bar and cancel link
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  ## SAMPLE DATA RECEIVED BY FILE UPLOAD!

  # META: %{path: "/tmp/plug-1607/live_view_upload-1607139895-597980406676796-1"}
  # ENTRY: %Phoenix.LiveView.UploadEntry{
  #   cancelled?: false,
  #   client_last_modified: nil,
  #   client_name: "art_vertical.mp4",
  #   client_size: 2954762,
  #   client_type: "video/mp4",
  #   done?: true,
  #   preflighted?: true,
  #   progress: 100,
  #   ref: "0",
  #   upload_config: :video,
  #   upload_ref: "phx-Fk21NZQy8jiiCQIF",
  #   uuid: "71968fca-f6db-402f-9b25-f3b9ca458c20",
  #   valid?: true
  # }

  def handle_event("save", _params, socket) do
    consume_uploaded_entries(socket, :video, fn meta, entry ->
      # Extract bin from meta.path
      bin = File.read!(meta.path)

      # Extract info from entry
      filename = entry.client_name
      id = entry.uuid

      # You need to pass user_id and trace_id to form component
      user_id = socket.assigns.user_id
      trace_id = socket.assigns.trace_id

      # Pass data to file_store and retrieve video params
      video_params = Bff.store_video(user_id, id, filename, bin)

      # Generate metadata for domain event
      metadata = %{
        "user_id" => user_id,
        "trace_id" => trace_id
      }

      # Create domain event command
      Bff.publish_video_command(
        video_params,
        metadata
      )
    end)

    {:noreply, socket}
  end

  def handle_event("cancel-entry", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :video, ref)}
  end
end
