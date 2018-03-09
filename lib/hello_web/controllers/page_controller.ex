defmodule HelloWeb.PageController do
  use HelloWeb, :controller

  def index(conn, _params) do
    test = get_session(conn, :key)
    if test == nil do
      conn = put_session(conn, :key, Phoenix.Token.sign(conn, "user salt", SecureRandom.uuid))
      test = get_session(conn, :key)
    end
    render conn, "index.html", key: test
  end
end
