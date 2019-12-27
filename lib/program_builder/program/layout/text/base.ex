defmodule ProgramBuilder.Program.Layout.Text.Base do
  @moduledoc """
  Text layout for a program
  """

  alias ProgramBuilder.Program.Meeting
  import ProgramBuilder.Utils.Music

  def layout(%Meeting{} = meet, opts \\ []) do
    meeting_date = Keyword.get(opts, :date, Date.utc_today())

    EEx.eval_string(
      """
      Sacrament Meeting Agenda for <%= meeting_date %>

      Welcome to The Church of Jesus Christ of Latter-day Saints
      This is the Provo Married Student 11th Ward

      Conducting: <%= meet.conducting %>
      Presiding: <%= meet.presiding %>
      Visiting: <%= meet.visiting %>

      Chorister: <%= meet.chorister %>
      Accompanist: <%= meet.accompanist %>

      Announcements
      -------------
        - If you are new to the ward, please meet with a memeber of the bishopric in the foyer after the meeting

      Opening Hymn: #<%= meet.opening_hymn %>, <%= hymn_name.(meet.opening_hymn) %>

      Invocation: <%= meet.invocation %>

      --------------------------------------------------

      Ward Business:

       - Releases
       - Sustainings

      Stake Business:

      New Member Records:
      "The memberships for the following individuals have been received; if you are present, please stand when your name is read".
      *read records*
      Those who can welcome these new members of the ward please manifest it.

      Baby Blessing:

      --------------------------------------------------

      Sacrament Hymn: #<%= meet.sacrament_hymn %> <%= hymn_name.(meet.sacrament_hymn) %>

      *Administration of the Sacrament*

      --------------------------------------------------

      <%= for event <- meet.event_ids do %> <%= case event do %>
      <%= %ProgramBuilder.Program.Event.Talk{} -> %>
       - Speaker: <%= event.visitor %> 
          <% end %> <% end %>

      --------------------------------------------------

      Closing Hymn: #<%= meet.closing_hymn %> <%= hymn_name.(meet.closing_hymn) %>

      Benediction: <%= meet.benediction %>
      """,
      meeting_date: meeting_date,
      meet: meet,
      hymn_name: &hymn_name/1
    )
  end

  def sigil_E(str, _opts \\ []) do
    EEx.eval_string(str)
  end
end
