defmodule LessonOne do
  import Example.Calculator, only: [sum: 2]

  require Logger

  def hello(name) do
    "Hola " <> name
  end

  def hello2(name), do: "Hola 2 " <> name
end
