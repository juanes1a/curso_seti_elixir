defmodule CursoSeti.Config.AppConfig do

  @moduledoc """
   Provides strcut for app-config
  """

   defstruct [
     :enable_server,
     :http_port,
     :redis_host,
     :redis_port,
     :cache_expiration
   ]

   def load_config do
     %__MODULE__{
       enable_server: load(:enable_server),
       http_port: load(:http_port),
       redis_host: load(:redis_host),
       redis_port: load(:redis_port),
       cache_expiration: load(:cache_expiration)
     }
   end

   defp load(property_name), do: Application.fetch_env!(:cursoseti, property_name)
 end
