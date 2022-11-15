defmodule CursoSeti.Infrastructure.DrivenAdapters.Cache.UserCache do

  @behaviour CursoSeti.Domain.Behaviours.User.UserBehaviour

  @expiration_time Application.compile_env!(:cursoseti, :cache_expiration)

  def save_user(user) do
    user_encode = Poison.encode!(user)
    Redix.command(:redix, ["SETEX", "#{user.document_type}-#{user.document_number}", @expiration_time, user_encode])
    |> extract()
  end

  defp extract(response) do
    case response do
      {:ok, nil} -> {:error, :couldnt_save_user}
      {:ok, 0} -> {:error, :couldnt_save_user}
      {:ok, "OK"} -> {:ok, :true}
      other -> other
    end
  end

end
