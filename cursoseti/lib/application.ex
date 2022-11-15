defmodule CursoSeti.Application do
  alias CursoSeti.Infrastructure.EntryPoint.ApiRest
  alias CursoSeti.Config.{AppConfig, ConfigHolder}
  alias CursoSeti.Utils.CertificatesAdmin
  alias Cursoseti.Utils.CustomTelemetry
  alias CursoSeti.Infrastructure.DrivenAdapters.Cache.Redis

  use Application
  require Logger

  def start(_type, _args) do
    config = AppConfig.load_config()

    CertificatesAdmin.setup()

    children = with_plug_server(config) ++ all_env_children() ++ env_children(Mix.env())

    CustomTelemetry.custom_telemetry_events()
    opts = [strategy: :one_for_one, name: CursoSeti.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp with_plug_server(%AppConfig{enable_server: true, http_port: port}) do
    Logger.debug("Configure Http server in port #{inspect(port)}. ")
    [{Plug.Cowboy, scheme: :http, plug: ApiRest, options: [port: port]}]
  end

  defp with_plug_server(%AppConfig{enable_server: false}), do: []

  def all_env_children() do
    [
      {ConfigHolder, AppConfig.load_config()},
      {TelemetryMetricsPrometheus, [metrics: CustomTelemetry.metrics()]}
    ]
  end

  @spec env_children(any) :: [{CursoSeti.Infrastructure.DrivenAdapters.Cache.Redis, []}]
  def env_children(:test) do
    []
  end

  def env_children(_other_env) do
    [
      {Redis, []}
    ]
  end
end
