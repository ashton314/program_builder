defmodule ProgramBuilder.Meeting.Layout do
  require EEx
  require Logger
  import ProgramBuilder.Utils.Music

  EEx.function_from_file(:def, :latex, "lib/program_builder/program/layout/latex/meeting.latex.eex", [:meeting])

  def italic(str, opts \\ []), do: "\\textit{#{disp(str, opts)}}"

  def member_name(id, opts \\ [])
  def member_name(id, opts) when is_integer(id) do
    member = ProgramBuilder.People.get_member(id)

    if member, do: disp(member.name, opts), else: disp("Invalid Member ID")
  end
  def member_name(_, opts), do: disp(nil, opts)

  def disp_hymn(num, opts \\ [])
  def disp_hymn(nil, opts) do
    disp(nil, opts)
  end
  def disp_hymn("", opts), do: disp(nil, opts)
  def disp_hymn(num, opts) when is_integer(num) do
    "#{num} #{italic(hymn_name(num),opts)}"
  end

  @doc """
  Escapes the string, or displays an underline
  """
  def disp(str, opts \\ [])
  def disp("", opts), do: disp(nil, opts)
  def disp(nil, opts) do
    if Keyword.get(opts, :underline, false) do
      "\\uline{#{Keyword.get(opts, :filler_text, "Nice Long Blank Line")}}"
    else
      Keyword.get(opts, :filler_text, "(None Given)")
    end
  end
  def disp(str, _opts) do
    escape(pretty_print(str))
  end

  def pretty_print(%Date{} = date) do
    Timex.Format.DateTime.Formatter.format!(date, "{D} {Mfull} {YYYY}")
  end
  def pretty_print(x), do: x

  def escape(foo) when not is_binary(foo), do: escape(to_string(foo))

  def escape(""), do: ""
  def escape("\\" <> rest), do: "\\\\" <> escape(rest)
  def escape("{" <> rest), do: "\\{" <> escape(rest)
  def escape("}" <> rest), do: "\\}" <> escape(rest)
  def escape(any) do
    {head, tail} = String.next_grapheme(any)
    head <> escape(tail)
  end
end
