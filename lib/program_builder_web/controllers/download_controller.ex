defmodule ProgramBuilderWeb.DownloadController do
  use ProgramBuilderWeb, :controller

  require Logger

  def download(conn, %{"token" => token}) do
    Logger.debug("Rendering download for token #{inspect token}")
    {:ok, path} = ProgramBuilder.Utils.FormatLatex.retrieve_from_token(token)
    send_download(conn, {:file, path}, filename: "program.pdf")
  end
end
