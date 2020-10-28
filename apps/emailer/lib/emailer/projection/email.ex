defmodule Emailer.Projection.Email do
  defstruct from: nil,
            to: nil,
            subject: nil,
            text: nil,
            html: nil,
            is_sent: false
end
