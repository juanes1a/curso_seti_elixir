defmodule Lenght do
  def handle(data) do
    with {:ok, response} <- function_1(data),
         {:ok, true} <- function_2(response) do
      response
      "Todo bien"
    else
      {:error, :invaid_data} -> "Data invalida"
      _ ->
        "Algo mal"
    end
  end

  def function_1(_data) do
    {:ok, false}
  end

  def function_2(true) do
    {:ok, true}
  end

  def function_2(false) do
    {:error, :invaid_data}
  end
end
