defmodule CursoSeti.Infrastructure.DrivenAdapters.Cache.UserCacheTest do

  alias CursoSeti.Infrastructure.DrivenAdapters.Cache.UserCache
  import TestStubs
  import Mock

  use ExUnit.Case
  doctest CursoSeti.Application

  describe "save_user/1" do
    test "Shlould save user successfully" do
      with_mock Redix,
        command: fn _, _ -> {:ok, "OK"} end do
          response = UserCache.save_user(%{document_type: "", document_number: "", name: ""})
          assert response = {:ok, true}
        end
    end

    test "Shlould return error couldnt save user" do
      with_mock Redix,
        command: fn _, _ -> {:ok, nil} end do
          response = UserCache.save_user(%{document_type: "", document_number: "", name: ""})
          assert response = {:error, :couldnt_save_user}
        end
    end

    test "Shlould return error couldnt save user with 0" do
      with_mock Redix,
        command: fn _, _ -> {:ok, 0} end do
          response = UserCache.save_user(%{document_type: "", document_number: "", name: ""})
          assert response = {:error, :couldnt_save_user}
        end
    end

    test "Shlould return unexpected error" do
      with_mock Redix,
        command: fn _, _ -> {:error, :error} end do
          response = UserCache.save_user(%{document_type: "", document_number: "", name: ""})
          assert response = {:error, :error}
        end
    end
  end
end
