defmodule Emailer.Core.Email do
  import Bamboo.Email

  def build_email(opts \\ []) do
    to = Keyword.get(opts, :to, nil)
    subject = Keyword.get(opts, :subject, "Welcome to the app.")
    html_body = Keyword.get(opts, :html_body, "<strong>Thanks for joining!</strong>")
    text_body = Keyword.get(opts, :text_body, "Thanks for joining!")

    new_email(
      to: to,
      from: sender(),
      subject: subject,
      html_body: html_body,
      text_body: text_body
    )
  end

  defp sender() do
    Application.get_env(:emailer, :sender)
  end
end
