defmodule Tiki.Token do
  @moduledoc """
  Support exchange access token and refresh token APIs
  """

  alias Tiki.Client

  @endpoint "https://api.tiki.vn/sc/oauth2"

  @doc """
  Exchange code for access token

  Reference: https://open.tiki.vn/docs/docs/current/oauth-2-0/auth-flows/authorization-code-flow/
  """
  @get_access_token_schema %{
    redirect_uri: [type: :string, required: true],
    client_id: [type: :string, required: true],
    client_secret: [type: :string, required: true],
    code: [type: :string, required: true],
    grant_type: [type: :string, default: "authorization_code"]
  }
  def get_access_token(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @get_access_token_schema),
         {:ok, client} <-
           Client.new([endpoint: @endpoint, form_data: true] ++ opts) do
      Client.post(client, "/token", data)
    end
  end

  @doc """
  Exchange refresh token for new access token

  Reference: https://open.tiki.vn/docs/docs/current/oauth-2-0/auth-flows/refresh-token/
  """
  @refresh_token_schema %{
    client_id: [type: :string, required: true],
    client_secret: [type: :string, required: true],
    refresh_token: [type: :string, required: true],
    grant_type: [type: :string, default: "refresh_token"]
  }
  def refresh_token(params, opts \\ []) do
    with {:ok, data} <- Contrak.validate(params, @refresh_token_schema),
         {:ok, client} <-
           Client.new([endpoint: @endpoint, form_data: true] ++ opts) do
      Client.post(client, "/token", data)
    end
  end
end
