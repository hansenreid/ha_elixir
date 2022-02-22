defmodule HaElixir.Repo do
  use Ecto.Repo,
    otp_app: :ha_elixir,
    adapter: Ecto.Adapters.Postgres
end
