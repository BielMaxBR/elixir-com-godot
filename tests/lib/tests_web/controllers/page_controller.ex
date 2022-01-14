defmodule TestsWeb.PageController do
  use TestsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
