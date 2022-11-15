defmodule CursoSeti.Infrastructure.EntryPoint.ApiRestRequestValidation do

  require Logger

  @client_id_application "123"

  def validate_request_body(request) when request == %{} do
    {:error, :missing_body}
  end

  def validate_request_body(request) when request.data == nil or request.data == [] do
    {:error, :missing_body}
  end

  def validate_request_body(request) do
    request.data
    |> List.first()
    |> case do
      nil -> {:error, :missing_body}
      body -> {:ok, body}
    end
  end

  def validate_headers(%{"client-id" => client_id}) do
    with {:ok, true} <- validate_client_id(client_id) do
      {:ok, true}
    else
      error ->
        Logger.error("Error validando header #{inspect(error)}")
        error
    end
  end

  def validate_headers(_headers) do
    {:error, :client_id_not_authorized}
  end

  defp validate_client_id(client_id) when client_id == nil or client_id == "" do
    {:error, :client_id_not_authorized}
  end

  defp validate_client_id(client_id) do
    String.equivalent?(client_id, @client_id_application)
    |> case do
      true -> {:ok, true}
      false -> {:error, :client_id_not_authorized}
    end
  end


end
