defmodule BSON.TypesTest do
  use ExUnit.Case, async: true

  import BSON, only: [decode: 1]

  test "inspect BSON.Binary" do
    value = %BSON.Binary{binary: <<1, 2, 3>>}
    assert inspect(value) == "#BSON.Binary<010203>"

    value = %BSON.Binary{binary: <<1, 2, 3>>, subtype: :uuid}
    assert inspect(value) == "#BSON.Binary<010203, uuid>"
  end

  test "inspect BSON.ObjectId" do
    value = %BSON.ObjectId{value: <<29, 32, 69, 244, 101, 119, 228, 28, 61, 24, 21, 215>>}
    assert inspect(value) == "#BSON.ObjectId<1d2045f46577e41c3d1815d7>"
  end

  test "inspect BSON.DateTime" do
    value = %BSON.DateTime{utc: 1437940203000}
    assert inspect(value) == "#BSON.DateTime<2015-07-26T19:50:03Z>"
  end

  test "inspect BSON.Regex" do
    value = %BSON.Regex{pattern: "abc"}
    assert inspect(value) == "#BSON.Regex<\"abc\">"

    value = %BSON.Regex{pattern: "abc", options: "i"}
    assert inspect(value) == "#BSON.Regex<\"abc\", \"i\">"
  end

  test "inspect BSON.JavaScript" do
    value = %BSON.JavaScript{code: "this === null"}
    assert inspect(value) == "#BSON.JavaScript<\"this === null\">"

    value = %BSON.JavaScript{code: "this === value", scope: %{value: nil}}
    assert inspect(value) == "#BSON.JavaScript<\"this === value\", %{value: nil}>"
  end

  test "inspect BSON.Timestamp" do
    value = %BSON.Timestamp{value: 1412180887}
    assert inspect(value) == "#BSON.Timestamp<1412180887>"
  end
  
  @mapPosInf %{"a" => :inf}
  @binPosInf <<16, 0, 0, 0, 1, 97, 0, 0, 0, 0, 0, 0, 0, 240::little-integer-size(8), 127::little-integer-size(8), 0>>

  @mapNegInf %{"a" => :"-inf"}
  @binNegInf <<16, 0, 0, 0, 1, 97, 0, 0, 0, 0, 0, 0, 0, 240::little-integer-size(8), 255::little-integer-size(8), 0>>

  @mapNaN %{"a" => :NaN}
  @binNaN <<16, 0, 0, 0, 1, 97, 0, 0, 0, 0, 0, 0, 0, 248::little-integer-size(8), 127::little-integer-size(8), 0>>

  test "decode float NaN" do
    assert decode(@binNaN) == @mapNaN
  end

  test "encode float NaN" do
    assert encode(@mapNaN) == @binNaN
  end

  test "decode float positive Infinity" do
    assert decode(@binPosInf) == @mapPosInf
  end

  test "encode float positive Infinity" do
    assert encode(@mapPosInf) == @binPosInf
  end

  test "decode float negative Infinity" do
    assert decode(@binNegInf) == @mapNegInf
  end

  test "encode float negative Infinity" do
    assert encode(@mapNegInf) == @binNegInf
  end
  
  defp encode(value) do
    value |> BSON.encode |> IO.iodata_to_binary
  end
end
