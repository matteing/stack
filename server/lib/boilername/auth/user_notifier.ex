defmodule BoilerName.Auth.UserNotifier do
  use Phoenix.Swoosh,
    view: BoilerNameWeb.EmailView,
    layout: {BoilerNameWeb.LayoutView, :email}

  alias BoilerName.Mailer

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, token) do
    new()
    |> from("hey@boilername.com")
    |> to(user.email)
    |> subject("Confirmation link")
    |> render_body("confirmation.html", %{user: user, token: token})
    |> Mailer.deliver()
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, token) do
    new()
    |> from("hey@boilername.com")
    |> to(user.email)
    |> subject("Password reset link")
    |> render_body("forgot_password.html", %{user: user, token: token})
    |> Mailer.deliver()
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(_user, _url) do
    # TODO
  end
end
