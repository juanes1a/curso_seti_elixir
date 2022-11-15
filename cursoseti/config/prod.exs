import Config

config :cursoseti, timezone: "America/Bogota"

config :cursoseti,
  http_port: 8083,
  enable_server: true,
  secret_name: "",
  region: "",
  version: "0.0.1",
  in_test: false,
  custom_metrics_prefix_name: ""

config :logger,
  level: :debug

config :cursoseti,
  user_repository: CursoSeti.Infrastructure.DrivenAdapters.Cache.UserCache
