defmodule CursoSeti.Infrastructure.EntryPoint.ErrorHandler do

  def build_error(error) do
    error
    |> build_error_response()
    |> make_error_request()
  end

  defp build_error_response({:error, :missing_body}) do
    %{
      code: "ERR01",
      detail: "Parametros incorrectos del request"
    }
  end

  defp build_error_response({:error, :client_id_not_authorized}) do
    %{
      code: "ERR02",
      detail: "Cliente no autorizado"
    }
  end

  defp build_error_response(_error) do
    %{
      code: "ERR0",
      detail: "Error desconocido"
    }
  end

  defp make_error_request(error_map) do
    %{
      "meta" => %{
        "requestDate" => get_request_date()
      },
      "data" => nil,
      "error" => [
        %{
          "status" => 400,
          "code" => error_map.code,
          "title" => "Error en la operación",
          "detail" => error_map.detail
        }
      ]
    }
  end

  defp get_request_date do
    now = DateTime.utc_now() |> Timex.to_datetime("America/Bogota")
    "#{now.day}/#{now.month}/#{now.year} #{now.hour}:#{now.minute}:#{now.second}"
  end


end
