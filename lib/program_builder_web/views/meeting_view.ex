defmodule ProgramBuilderWeb.MeetingView do
  use ProgramBuilderWeb, :view
  alias ProgramBuilder.Utils.Music
  alias ProgramBuilder.People

  def just_hymn_name(nil), do: "(None Given)"
  def just_hymn_name(num), do: Music.hymn_name(num)

  def add_tuple_id(thing), do: {System.unique_integer(), thing}

  def strip_tuple_id({_id, thing}), do: thing
  def strip_tuple_id(thing), do: thing

  def hymn_name(thing) when is_nil(thing) do
    content_tag(:p, "None Given", class: "font-italic text-muted")
  end

  def hymn_name("") do
    content_tag(:p, "None Given", class: "font-italic text-muted")
  end

  def hymn_name(thing) do
    content_tag(:p, Music.hymn_name(thing), class: "font-italic")
  end

  def list_display(nil) do
    content_tag(:p, "(None)", class: "font-italic text-muted")
  end

  def list_display([]) do
    content_tag(:p, "(None)", class: "font-italic text-muted")
  end

  def list_display(items) do
    content_tag(:ul, Enum.map(items, fn item -> content_tag(:li, item) end))
  end

  def display_or_none(first, second \\ [])
  def display_or_none(first, second) when is_binary(second),
    do: display_or_none(first, second, [])

  def display_or_none(first, second), do: display_or_none(first, "(None)", second)

  def display_or_none("", empty_message, options), do: display_or_none(nil, empty_message, options)

  def display_or_none(nil, empty_message, options) do
    options = Keyword.put_new(options, :class, "font-italic text-muted")
    content_tag(:span, empty_message, options)
  end

  def display_or_none(something, _empty_message, options) do
    content_tag(:span, something, options)
  end

  def member_name(nil), do: content_tag(:span, "(None)", class: "font-italic text-muted")
  def member_name(""), do: content_tag(:span, "(None)", class: "font-italic text-muted")

  def member_name(id) do
    member = People.get_member(id)

    if member,
      do: content_tag(:span, member.name),
      else: content_tag(:span, "Invalid Member ID", class: "help-block")
  end
end
