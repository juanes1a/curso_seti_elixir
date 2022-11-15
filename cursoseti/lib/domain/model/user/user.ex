defmodule CursoSeti.Domain.Model.User do
  alias __MODULE__

  @derive [Poison.Encoder]
  defstruct [
    :document_type,
    :document_number,
    :name
  ]

  def create_user_struct(map) do
    {:ok,
     %__MODULE__{
       document_type: map[:documentType] || "",
       document_number: map[:documentNumber] || "",
       name: map[:name] || ""
     }}
  end

  def validate_user_params(%User{
        document_type: "",
        document_number: "",
        name: ""
      }) do
    {:error, :missing_required_params}
  end

  def validate_user_params(%User{
    document_number: document_number
  }) when byte_size(document_number) < 5 do
    {:error, :missing_required_params}
  end

  def validate_user_params(_) do
    {:ok, true}
  end
end
