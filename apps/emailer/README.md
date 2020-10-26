# Emailer

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `emailer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:emailer, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/emailer](https://hexdocs.pm/emailer).

curl --request POST \
  --url https://api.sendgrid.com/v3/mail/send \
  --header "Authorization: Bearer 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" \
  --header 'Content-Type: application/json' \
  --data '{"personalizations": [{"to": [{"email": "koko.le.gorille@gmail.com"}]}],"from": {"email": "koko.le.gorille@gmail.com"},"subject": "Sending with SendGrid is Fun","content": [{"type": "text/plain", "value": "and easy to do anywhere, even with cURL"}]}'