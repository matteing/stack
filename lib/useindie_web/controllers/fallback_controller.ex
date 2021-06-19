defmodule UseIndieWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use UseIndieWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(UseIndieWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(UseIndieWeb.ErrorView)
    |> render(:"404")
  end

  # This clause handles authentication errors.
  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(UseIndieWeb.ErrorView)
    |> render(:"401")
  end

  # This clause handles any user submission problems.
  def call(conn, {:error, :bad_request, err}) do
    conn
    |> put_status(:bad_request)
    |> put_view(UseIndieWeb.ErrorView)
    |> render(:"400", error: err)
  end
end
