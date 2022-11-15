defmodule CursoSeti.Infrastructure.EntryPoint.ApiRest do
  @moduledoc """
  Access point to the rest exposed services
  """
  alias CursoSeti.Utils.DataTypeUtils
  alias CursoSeti.Infrastructure.EntryPoint.ApiRestRequestValidation
  alias CursoSeti.Domain.Model.User
  alias CursoSeti.Domain.UseCases.UserUseCase
  alias CursoSeti.Infrastructure.EntryPoint.ErrorHandler
  require Logger
  use Plug.Router
  use Timex

  plug(CORSPlug,
    methods: ["GET", "POST", "PUT", "DELETE"],
    origin: [~r/.*/],
    headers: ["Content-Type", "Accept", "User-Agent"]
  )

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Poison)
  plug(Plug.Telemetry, event_prefix: [:cursoseti, :plug])
  plug(:dispatch)

  forward(
    "/cursoseti/api/health",
    to: PlugCheckup,
    init_opts:
      PlugCheckup.Options.new(
        json_encoder: Jason,
        checks: CursoSeti.Infrastructure.EntryPoint.HealthCheck.checks()
      )
  )

  get "/cursoseti/api/hello/" do
    build_response("Hello World", conn)
  end

  post "/cursoseti/api/save_client" do
    request = conn.body_params |> DataTypeUtils.normalize()
    headers = conn.req_headers |> DataTypeUtils.normalize_headers()

    with {:ok, body} <- ApiRestRequestValidation.validate_request_body(request),
         {:ok, true} <- ApiRestRequestValidation.validate_headers(headers),
         {:ok, user} <- User.create_user_struct(body),
         {:ok, true} <- UserUseCase.save_user(user) do
      build_response(%{recibido: true}, conn)
    else
      error ->
        Logger.error("Error en el controlador #{inspect(error)}")
        ErrorHandler.build_error(error)
        |> build_bad_request_response(conn)
    end
  end

  def build_response(%{status: status, body: body}, conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Poison.encode!(body))
  end

  def build_response(response, conn), do: build_response(%{status: 200, body: response}, conn)

  match _ do
    conn
    |> handle_not_found(Logger.level())
  end

  defp build_bad_request_response(response, conn) do
    build_response(%{status: 400, body: response}, conn)
  end

  defp handle_not_found(conn, :debug) do
    %{request_path: path} = conn
    body = Poison.encode!(%{status: 404, path: path})
    send_resp(conn, 404, body)
  end

  defp handle_not_found(conn, _level) do
    send_resp(conn, 404, "")
  end
end
