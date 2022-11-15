defmodule CursoSeti.Domain.Behaviours.User.UserBehaviour do

  @callback save_user(user :: term) :: {:ok, status :: term} | {:error, reason :: term}

end
