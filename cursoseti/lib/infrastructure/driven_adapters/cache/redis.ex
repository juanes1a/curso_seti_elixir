defmodule CursoSeti.Infrastructure.DrivenAdapters.Cache.Redis do

  use GenServer
  require Logger
  alias CursoSeti.Config.ConfigHolder

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    %{
      redis_host: host,
      redis_port: port
    } = ConfigHolder.conf()

    Redix.start_link(host: host, port: String.to_integer(port), name: :redix)
  end

  def health() do
    Redix.command!(:redix, ["PING"])
    |> case do
      "PONG" -> {:ok, true}
       error -> {:error, error}
    end
  end

end
