ExUnit.start()

defmodule Termpaint.TestHelpers do
  import ExUnit.Assertions

  def assert_coords_marked(bitmap, ink \\ "x", coords) do
    expected_bitmap = for coord <- coords, into: %{}, do: {coord, ink}
    assert expected_bitmap == bitmap
  end
end
