defmodule UseIndieWeb.Auth do
  import Plug.Conn

  alias BoilerName.Auth

  def get_token(user) do
    Auth.generate_user_session_token(user)
  end

  def delete_token(token) do
    Auth.delete_session_token(token)

    # if live_socket_id = get_session(conn, :live_socket_id) do
    #  UseIndieWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    # end
  end

  @doc """
  Authenticates the user by looking into the session
  and remember me token.
  """
  def fetch_current_user(conn, _opts) do
    token = fetch_token(get_req_header(conn, "authorization"))
    user = token && Auth.get_user_by_session_token(token)
    assign(conn, :current_user, user)
  end

  @doc """
  Used for routes that require the user to not be authenticated.
  """
  def require_guest_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> put_status(401)
      |> Phoenix.Controller.put_view(UseIndieWeb.ErrorView)
      |> Phoenix.Controller.render(:"401")
      |> halt()
    else
      conn
    end
  end

  @doc """
  Used for routes that require the user to be authenticated.

  If you want to enforce the user email is confirmed before
  they use the application at all, here would be a good place.
  """
  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] != nil and conn.assigns[:current_user].is_active do
      conn
    else
      conn
      |> put_status(401)
      |> Phoenix.Controller.put_view(UseIndieWeb.ErrorView)
      |> Phoenix.Controller.render(:"401")
      |> halt()
    end
  end

  @doc """
  Used for routes that require the user to be authenticated and staff.

  If you want to enforce the user email is confirmed before
  they use the application at all, here would be a good place.
  """
  def require_staff_user(conn, _opts) do
    if conn.assigns[:current_user] != nil and conn.assigns[:current_user].is_staff do
      conn
    else
      conn
      |> put_status(401)
      |> Phoenix.Controller.put_view(UseIndieWeb.ErrorView)
      |> Phoenix.Controller.render(:"401")
      |> halt()
    end
  end

  # Taken from https://github.com/bobbypriambodo/phoenix_token_plug/blob/master/lib/phoenix_token_plug/verify_header.ex
  defp fetch_token([]), do: nil

  defp fetch_token([token | _tail]) do
    token
    |> String.replace("Token ", "")
    |> String.trim()
  end
end
