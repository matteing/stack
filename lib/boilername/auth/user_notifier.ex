defmodule BoilerName.Auth.UserNotifier do
  alias BoilerNameWeb.Mailer
  alias BoilerNameWeb.Email

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    Email.confirmation_email(url, user)
    |> Mailer.deliver_later!()
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    Email.forgot_password_email(url, user)
    |> Mailer.deliver_later!()
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(_user, _url) do
    # TODO
  end
end
