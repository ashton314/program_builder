defmodule ProgramBuilder.Utils.FormatLatex do

  @doc """
  Given a string, formats the LaTeX, and returns a Path to the
  formatted PDF file.
  """
  @spec format_string(str :: String.t()) :: {:ok, Path.t()} | {:error, String.t()}
  def format_string(str) do
    with {:ok, tmp} <- create_tmp(str),
         file <- Path.join(tmp, "program.tex"),
         :ok <- File.write(file, str) do
      run_latex(file)
    end
  end

  def create_tmp(data) do
    # Ensure we have a directory
    base_dir = Application.fetch_env!(:program_builder, :format_dir)
    unless File.dir?(base_dir) do
      File.mkdir!(base_dir)
    end

    # Generate a new unique path
    name = :crypto.hash(:sha512, data) |> Base.hex_encode32(case: :lower, padding: false) |> String.to_charlist() |> Enum.take(20) |> to_string()
    full_name = Path.join(base_dir, name)
    File.mkdir!(full_name)

    {:ok, full_name}
  end

  def run_latex(path) do
    {dir, file} = split_at_file(path)
    base_file = Path.basename(file, ".tex")
    IO.inspect(dir, label: :path_dir)
    with {_logs, 0} <- System.cmd("xelatex", ["-output-directory=#{dir}", path]) do
      # Cleanup
      for ext <- ~w(aux log out) do
        File.rm(Path.join(dir, "#{base_file}.#{ext}"))
      end

      {:ok, Path.join(dir, "#{base_file}.pdf")}
    end
  end

  def split_at_file(path) do
    {Path.dirname(path), Path.basename(path)}
  end
end
