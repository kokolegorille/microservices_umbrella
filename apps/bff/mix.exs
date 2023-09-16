defmodule Bff.MixProject do
  use Mix.Project

  def project do
    [
      app: :bff,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      # compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      compilers: [:phoenix | Mix.compilers()],
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Bff.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6.16"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.10"},
      {:phoenix_live_view, "~> 0.19"},
      {:phoenix_html, "~> 3.3"},
      {:phoenix_live_dashboard, "~> 0.8"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.23"},
      {:jason, "~> 1.4"},
      {:plug_cowboy, "~> 2.6"},
      #
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:floki, "~> 0.34", only: :test},

      # In Umbrella dependencies
      # Require emailer in dev to show sent_emails
      {:event_store, in_umbrella: true},
      {:identity, in_umbrella: true},
      {:emailer, in_umbrella: true},
      {:video_publishing, in_umbrella: true},
      {:video_store, in_umbrella: true},
      {:file_store, in_umbrella: true},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "cmd npm install --prefix assets"],
      # Add this for umbrella global reset
      "ecto.reset": []
    ]
  end
end
