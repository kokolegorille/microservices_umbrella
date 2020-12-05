defmodule VideoStore.Core do
  @moduledoc """
  Documentation for `Core`.
  """

  import Ecto.Query, warn: false

  alias VideoStore.Repo
  alias __MODULE__.{Aggregator, Video}

  @order_field :inserted_at

  #########################
  # AGGREGATOR
  #########################

  defdelegate replay(), to: Aggregator

  defdelegate load_video_publishing_events(), to: Aggregator

  #########################
  # EVENT STORE
  #########################

  def create_event(event) do
    EventStore.create_event(event)
  end


  #########################
  # Commands
  #########################

  def increment_views(id) do
    query = from Video, where: [id: ^id]
    Repo.update_all(query, inc: [views_count: 1])
  end

  def increment_likes(id) do
    query = from Video, where: [id: ^id]
    Repo.update_all(query, inc: [likes_count: 1])
  end

  def decrement_likes(id) do
    query = from Video, where: [id: ^id]
    Repo.update_all(query, inc: [likes_count: -1])
  end

  #
  def liked_by(%Video{} = video, user_id) do
    if user_id not in video.liked_by do
      video
      |> Ecto.Changeset.change(%{liked_by: [user_id | video.liked_by]})
      |> Repo.update()
    else
      {:ok, video}
    end
  end

  def unliked_by(%Video{} = video, user_id) do
    if user_id in video.liked_by do
      video
      |> Ecto.Changeset.change(%{liked_by: List.delete(video.liked_by, user_id)})
      |> Repo.update()
    else
      {:ok, video}
    end
  end

  def viewed_by(%Video{} = video, user_id) do
    if user_id not in video.viewed_by do
      video
      |> Ecto.Changeset.change(%{viewed_by: [user_id | video.viewed_by]})
      |> Repo.update()
    else
      {:ok, video}
    end
  end

  @doc """
  create video workflow.
  """
  def create_video(dto) do
    with {:ok, changeset} <- validate_video(dto),
         {:ok, video} <- persist(changeset, :insert) do
      {:ok, video}
    else
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  update video workflow.
  """
  def update_video(video, dto) do
    with {:ok, changeset} <- validate_video(video, dto),
         {:ok, video} <- persist(changeset, :update) do
      {:ok, video}
    else
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  delete video workflow.
  """
  def delete_video(video) do
    Repo.delete(video)
  end

  @doc """
  validate new video (no db).
  """
  def validate_video(dto) do
    validate_video(%Video{}, dto)
  end

  @doc """
  validate existing video (no db).
  """
  def validate_video(video, dto) do
    case Video.changeset(video, dto) do
      %{valid?: true} = changeset -> {:ok, changeset}
      %{valid?: false} = changeset -> {:error, changeset}
    end
  end

  # Private

  # Set idempotency with on conflict
  defp persist(valid_changeset, :insert) do
    Repo.insert(valid_changeset, on_conflict: :nothing)
  end

  defp persist(valid_changeset, :update) do
    Repo.update(valid_changeset)
  end

  #########################
  # Queries
  #########################

  @doc """
  list videos.
  """
  def list_videos(criteria \\ []) do
    criteria
    |> list_videos_query()
    |> Repo.all()
  end

  @doc """
  get video by id.
  """
  def get_video(id, opts \\ []) do
    video = Repo.get(Video, id)

    case opts[:preload] do
      nil -> video
      preload -> Repo.preload(video, preload)
    end
  end

  # Private

  defp list_videos_query(criteria) do
    query = from(p in Video)

    Enum.reduce(criteria, query, fn
      {:limit, limit}, query ->
        from(p in query, limit: ^limit)

      {:offset, offset}, query ->
        from(p in query, offset: ^offset)

      {:order, order}, query ->
        from(p in query, order_by: [{^order, ^@order_field}])

      {:preload, preloads}, query ->
        from(p in query, preload: ^preloads)

      _arg, query ->
        query
    end)
  end
end
