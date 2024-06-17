defmodule Page.Repo do
  use Ecto.Repo,
    otp_app: :page,
    adapter: Ecto.Adapters.Postgres
end
