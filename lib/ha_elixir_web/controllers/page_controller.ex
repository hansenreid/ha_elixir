defmodule HaElixirWeb.PageController do
  use HaElixirWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", service: System.get_env("SERVICE", "Default"))
  end
end
