defmodule CursoSeti.Domain.UseCases.UserUseCase do

  alias CursoSeti.Domain.Model.User

  require Logger

  @user_repository Application.compile_env!(:cursoseti, :user_repository)

  def save_user(%User{} = user) do
    with {:ok, true}  <- User.validate_user_params(user),
          {:ok, true} <- @user_repository.save_user(user) do
      {:ok, true}
    else
      error ->
        Logger.error("Error en caso de uso #{inspect(error)}")
        error
    end

  end

end
