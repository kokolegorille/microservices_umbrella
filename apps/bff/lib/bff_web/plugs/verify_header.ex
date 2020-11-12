defmodule BffWeb.Plugs.VerifyHeader do
  @moduledoc false
  import Plug.Conn

  def init(opts \\ []) do
    realm = Keyword.get(opts, :realm, "Bearer")

    case realm do
      "" ->
        opts

      :none ->
        opts

      _realm ->
        {:ok, reg} = Regex.compile("#{realm}\:?\s+(.*)$", "i")
        Keyword.put(opts, :realm_reg, reg)
    end
  end

  def call(conn, opts) do
    case fetch_token_from_header(conn, opts) do
      {:ok, token} ->
        assign(conn, :token, token)

      :no_token_found ->
        conn
    end
  end

  defp fetch_token_from_header(conn, opts) do
    # Keys in the header are lower case!
    # Even if send as Authorization!
    headers = get_req_header(conn, "authorization")
    fetch_token_from_header(conn, opts, headers)
  end

  defp fetch_token_from_header(_, _, []), do: :no_token_found

  defp fetch_token_from_header(conn, opts, [token | tail]) do
    reg = Keyword.get(opts, :realm_reg, ~r/^(.*)$/)
    trimmed_token = String.trim(token)

    case Regex.run(reg, trimmed_token) do
      [_, match] -> {:ok, String.trim(match)}
      _ -> fetch_token_from_header(conn, opts, tail)
    end
  end
end
