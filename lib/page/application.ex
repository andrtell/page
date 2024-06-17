defmodule Page.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PageWeb.Telemetry,
      Page.Repo,
      {DNSCluster, query: Application.get_env(:page, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Page.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Page.Finch},
      # Start a worker by calling: Page.Worker.start_link(arg)
      # {Page.Worker, arg},
      # Start to serve requests, typically the last entry
      PageWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Page.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PageWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
