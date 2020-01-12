defmodule ProgramBuilder.Auth.Permissions do
  @moduledoc """
  Business logic to check if users can perform certain actions
  """

  alias ProgramBuilder.Auth.{Unit,User}
  alias ProgramBuilder.Program.Meeting
  alias ProgramBuilder.People.Member

  # Used for checking whether or not a user can create members
  def can_create?(%User{} = user, %Unit{} = unit) do
    # FIXME: check user roles
    user.unit_id == unit.id
  end


  def can_access?(%User{} = user, %Meeting{} = meeting) do
    user.unit_id == meeting.unit_id
  end
  def can_access?(%Unit{} = unit, %Meeting{} = meeting) do
    unit.id == meeting.unit_id
  end
  def can_access?(%User{} = user, %Member{} = member) do
    user.unit_id == member.unit_id
  end

  def can_edit?(%User{} = user, %Meeting{} = meeting) do
    # FIXME: make this check the role on the user
    can_access?(user, meeting) and true
  end
  def can_edit?(%User{} = user, %Member{} = member) do
    can_access?(user, member)
  end


  def can_delete?(%User{} = user, %Member{} = member) do
    can_edit?(user, member)
  end
end
