defmodule Tiki.Type.CommaSeparatedString do
  @moduledoc """
  Helper type support CommaSeparatedString from value list

  ## How to use

  - Build schema:

      schema = %{
        status: [type: CommaSeparatedString, func: {CommaSeparatedString, :validate, [["active", "inactive", "deleted"]]}, into: {CommaSeparatedString, :dump}]
      }

      # or
      schema = %{
        status: CommaSeparatedString.type(["active", "inactive"])
      }

  - Cast

      Tarams.cast(%{status:  ["active", "inactive"]}, schema)

  """
  alias Tiki.Type.CommaSeparatedString

  @doc """
  Cast operator values from tuple of `{operator, [values]}`
  """
  def cast(values) when is_list(values) do
    {:ok, values}
  end

  def cast(_), do: {:error, "invalid values, only accept list"}

  @doc """
  Serialize list to string
  """
  def dump(nil, _), do: {:ok, nil}

  def dump(values, _) do
    {:ok, Enum.join(values, ",")}
  end

  @doc """
  Validate values in the allowed_values
  """
  def validate(nil, _values, _), do: :ok

  def validate(allowed_values, values, _) when is_list(allowed_values) do
    if Enum.all?(values, &(&1 in allowed_values)) do
      :ok
    else
      {:error, "invalid value item, only accept #{inspect(allowed_values)}"}
    end
  end

  @doc """
  Helper module to build schema expression for CommaSeparatedString type
  """
  def type(opts \\ []) do
    {allowed_values, opts} = Keyword.pop(opts, :in)

    [
      type: CommaSeparatedString,
      func: {CommaSeparatedString, :validate, [allowed_values]},
      into: {CommaSeparatedString, :dump}
    ] ++ opts
  end
end
