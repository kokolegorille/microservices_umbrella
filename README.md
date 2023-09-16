# MicroservicesUmbrella

Building an Elixir application with CQRS/ES.

This is a demo application translated from the book [Practical Microservices](https://pragprog.com/titles/egmicro/practical-microservices/).

Translated from Node to Elixir, w/ some adaptation to actor model.

## Configuration

To make it work, You need to set the path for files and videos in config/dev.exs to a writable location.

```
# FILE STORE
# Configure where to save files...
config :file_store,
  storage_dir_prefix: "/path/to/uploads"

# Video
# Configure where to save videos...
config :bff, uploads_directory: "/path/to/uploads"
```

## Bff

Backend for frontend, liveview endpoint

## EventStore

Store domain events, required by all systems
Use postgresql

## FileStore

Used to persists uploads

## Emailer

Send email on demand

## Identity

Use postgresql
Store user identities

## VideoPublishing

Check video creation

## VideoStore

Use postgresql
View video data

## Update to Phoenix 1.6
Septembre 2023

### Changes

```
% git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	deleted:    apps/api_gw/.formatter.exs
	deleted:    apps/api_gw/.gitignore
	deleted:    apps/api_gw/README.md
	deleted:    apps/api_gw/lib/api_gw.ex
	deleted:    apps/api_gw/lib/api_gw/application.ex
	deleted:    apps/api_gw/lib/api_gw_web.ex
	deleted:    apps/api_gw/lib/api_gw_web/channels/presence.ex
	deleted:    apps/api_gw/lib/api_gw_web/channels/user_socket.ex
	deleted:    apps/api_gw/lib/api_gw_web/controllers/authentication_controller.ex
	deleted:    apps/api_gw/lib/api_gw_web/controllers/event_controller.ex
	deleted:    apps/api_gw/lib/api_gw_web/controllers/fallback_controller.ex
	deleted:    apps/api_gw/lib/api_gw_web/controllers/registration_controller.ex
	deleted:    apps/api_gw/lib/api_gw_web/controllers/video_controller.ex
	deleted:    apps/api_gw/lib/api_gw_web/endpoint.ex
	deleted:    apps/api_gw/lib/api_gw_web/gettext.ex
	deleted:    apps/api_gw/lib/api_gw_web/plugs/ensure_authenticated.ex
	deleted:    apps/api_gw/lib/api_gw_web/plugs/verify_header.ex
	deleted:    apps/api_gw/lib/api_gw_web/router.ex
	deleted:    apps/api_gw/lib/api_gw_web/telemetry.ex
	deleted:    apps/api_gw/lib/api_gw_web/token_helpers.ex
	deleted:    apps/api_gw/lib/api_gw_web/views/authentication_view.ex
	deleted:    apps/api_gw/lib/api_gw_web/views/error_helpers.ex
	deleted:    apps/api_gw/lib/api_gw_web/views/error_view.ex
	deleted:    apps/api_gw/lib/api_gw_web/views/event_view.ex
	deleted:    apps/api_gw/lib/api_gw_web/views/registration_view.ex
	deleted:    apps/api_gw/lib/api_gw_web/views/video_view.ex
	deleted:    apps/api_gw/mix.exs
	deleted:    apps/api_gw/priv/gettext/en/LC_MESSAGES/errors.po
	deleted:    apps/api_gw/priv/gettext/errors.pot
	deleted:    apps/api_gw/test/api_gw_web/views/error_view_test.exs
	deleted:    apps/api_gw/test/support/channel_case.ex
	deleted:    apps/api_gw/test/support/conn_case.ex
	deleted:    apps/api_gw/test/test_helper.exs
	modified:   apps/bff/assets/package-lock.json
	modified:   apps/bff/assets/package.json
	modified:   apps/bff/lib/bff_web.ex
	modified:   apps/bff/lib/bff_web/live/register/register_live.html.heex
	modified:   apps/bff/lib/bff_web/live/session/session_live.html.heex
	modified:   apps/bff/lib/bff_web/live/video_live/form_component.ex
	modified:   apps/bff/lib/bff_web/live/video_live/form_component.html.heex
	modified:   apps/bff/lib/bff_web/live/video_live/index.html.heex
	modified:   apps/bff/lib/bff_web/templates/layout/live.html.heex
	modified:   apps/bff/mix.exs
	modified:   apps/event_store/mix.exs
	modified:   apps/identity/lib/identity/core.ex
	modified:   apps/identity/lib/identity/core/user.ex
	modified:   apps/identity/mix.exs
	modified:   apps/video_store/mix.exs
	modified:   config/config.exs
	modified:   config/dev.exs
	modified:   config/prod.exs
	modified:   config/releases.exs
	modified:   mix.lock

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	apps/bff/lib/bff_web/live/components/
```

## Fix webpack config, fix video form

```
% git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   README.md
	modified:   apps/bff/assets/package-lock.json
	modified:   apps/bff/assets/webpack.config.js
	modified:   apps/bff/lib/bff_web.ex
	modified:   apps/bff/lib/bff_web/endpoint.ex
	modified:   apps/bff/lib/bff_web/live/video_live/form_component.ex
	modified:   apps/bff/lib/bff_web/live/video_live/form_component.html.heex
```
