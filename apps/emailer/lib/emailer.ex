defmodule Emailer do
  @moduledoc """
  Documentation for `Emailer`.
  """

  alias __MODULE__.Core.{Mailer, Email}
  alias __MODULE__.Projection

  @doc """
  Send an email directly.

  ## Examples

      iex> Emailer.delliver_now(email)
      16:33:50.093 [debug] Sending email with Bamboo.SendGridAdapter:
  """
  defdelegate deliver_now(email, opts \\ []), to: Mailer

  @doc """
  Send an email later.

  ## Examples

      iex> Emailer.delliver_later(email)
      16:33:50.093 [debug] Sending email with Bamboo.SendGridAdapter:
  """
  defdelegate deliver_later(email, opts \\ []), to: Mailer

  @doc """
  Build an email.

  ## Examples

      iex> Emailer.build_email([to: "xxx@yyy.zz", subject: "test", html_body: "Yo <strong>Meli7!</strong>", text_body: "Yo Meli7!"])
      %Bamboo.Email{
        assigns: %{},
        attachments: [],
        bcc: nil,
        cc: nil,
        from: "xxx@yyy.zz",
        headers: %{},
        html_body: "Yo <strong>Meli7!</strong>",
        private: %{},
        subject: "test",
        text_body: "Yo Meli7!",
        to: "xxx@yyy.zz"
      }
  """
  defdelegate build_email(opts \\ []), to: Email

  defdelegate replay, to: Projection
end
