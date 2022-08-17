defmodule Tiki.Type.SetExpression do
  @moduledoc """
  Helper type support Tiki SetExpression

  ## How to use

  - Build schema:

      schema = %{
        status: [type: SetExpression, func: {SetExpression, :validate, [["active", "inactive", "deleted"]]}, into: {SetExpression, :dump}]
      }

  - Cast

      Tarams.cast(%{status: {:in, ["active", "inactive"]}}, schema)
      #or
      exp = SetExpression.new(:in, ["active", "inactive"])
      Tarams.cast(%{status: exp}, schema)

  """
  alias Tiki.Type.SetExpression
  defstruct operator: nil, values: []
  @allowed_operators [:in, :nin]

  @doc """
  Build new Set expression from operator and value
  """
  def new(operator, values) do
    with {:operator, true} <- {:operator, operator in @allowed_operators},
         {:values, true} <- {:values, is_list(values) and length(values) > 0} do
      %__MODULE__{operator: operator, values: values}
    else
      {:operator, _} -> raise "operator is not allowed. Only use: in | nin"
      {:values, _} -> raise "value must be a list"
    end
  end

  @doc """
  Cast operator values from tuple of `{operator, [values]}`
  """
  def cast(%__MODULE__{} = value) do
    {:ok, value}
  end

  def cast({operator, values}) when is_list(values) do
    try do
      {:ok, new(operator, values)}
    rescue
      e ->
        {:error, e.message}
    end
  end

  def cast(_), do: {:error, "invalid set expression. Accept tuple of: {operator, [values]}"}

  @doc """
  Serialize expression to string
  """
  def dump(nil, _), do: {:ok, nil}

  def dump(expression, _) do
    {:ok, "#{expression.operator}|#{Enum.join(expression.values, ",")}"}
  end

  @doc """
  Validate expression value in the allowed_values
  """
  def validate(nil, _expression, _), do: :ok

  def validate(allowed_values, expression, _) when is_list(allowed_values) do
    if Enum.all?(expression.values, &(&1 in allowed_values)) do
      :ok
    else
      {:error, "invalid expression value"}
    end
  end

  @doc """
  Helper module to build schema expression for SetExpression type
  """
  def type(opts \\ []) do
    {allowed_values, opts} = Keyword.pop(opts, :in)

    [
      type: SetExpression,
      func: {SetExpression, :validate, [allowed_values]},
      into: {SetExpression, :dump}
    ] ++ opts
  end
end
