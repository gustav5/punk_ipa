defmodule PunkFrontTest do
  use ExUnit.Case
  doctest PunkFront

  test "greets the world" do
    assert PunkFront.hello() == :world
  end
end
