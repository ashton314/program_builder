defmodule ProgramBuilderWeb.MeetingView do
  use ProgramBuilderWeb, :view
  alias ProgramBuilder.Utils.Music

  def hymn_name(thing) when is_nil(thing) do
    content_tag(:p, "None Given", class: "font-italic text-muted")
  end

  def hymn_name("") do
    content_tag(:p, "None Given", class: "font-italic text-muted")
  end

  def hymn_name(thing) do
    content_tag(:p, Music.hymn_name(thing), class: "font-italic")
  end
end
