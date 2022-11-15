defmodule LessonOneTest do
  use ExUnit.Case
  doctest LessonOne

  test "greets the world" do
    assert LessonOne.hello() == :world
  end
end
