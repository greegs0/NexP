# frozen_string_literal: true

# Service pour gérer l'adhésion aux projets
#
# Usage:
#   service = ProjectMembershipService.new(project, user)
#   result = service.join
#   result = service.leave
#
class ProjectMembershipService
  class AlreadyMemberError < StandardError; end
  class NotMemberError < StandardError; end
  class ProjectFullError < StandardError; end
  class OwnerCannotLeaveError < StandardError; end

  attr_reader :project, :user

  def initialize(project, user)
    @project = project
    @user = user
  end

  # Rejoindre un projet
  #
  # @return [Team] L'équipe créée
  # @raise [AlreadyMemberError] Si l'utilisateur est déjà membre
  # @raise [ProjectFullError] Si le projet est complet
  def join
    raise AlreadyMemberError, "Vous êtes déjà membre de ce projet." if member?
    raise ProjectFullError, "Ce projet est complet." if project_full?

    team = nil

    Project.transaction do
      project.lock!

      # Re-vérifier après le lock (évite les race conditions)
      raise ProjectFullError, "Ce projet est complet." if project_full?

      team = project.teams.create!(
        user: user,
        role: 'member',
        status: 'accepted',
        joined_at: Time.current
      )

      project.increment!(:current_members_count)
    end

    # Attribuer XP après la transaction
    ExperienceService.award(user: user, action: :project_joined) if defined?(ExperienceService)

    team
  end

  # Quitter un projet
  #
  # @return [Boolean] true si réussi
  # @raise [NotMemberError] Si l'utilisateur n'est pas membre
  # @raise [OwnerCannotLeaveError] Si l'utilisateur est le propriétaire
  def leave
    team = project.teams.find_by(user: user)
    raise NotMemberError, "Vous ne faites pas partie de ce projet." unless team
    raise OwnerCannotLeaveError, "Le créateur ne peut pas quitter son propre projet." if owner?

    Project.transaction do
      project.lock!
      team.destroy!
      project.decrement!(:current_members_count)
    end

    true
  end

  # Vérifie si l'utilisateur est membre
  #
  # @return [Boolean]
  def member?
    project.members.include?(user)
  end

  # Vérifie si l'utilisateur est le propriétaire
  #
  # @return [Boolean]
  def owner?
    project.owner == user
  end

  # Vérifie si le projet est complet
  #
  # @return [Boolean]
  def project_full?
    project.current_members_count >= project.max_members
  end

  # Vérifie si l'utilisateur peut rejoindre
  #
  # @return [Boolean]
  def can_join?
    !member? && !project_full? && project.accepting_members?
  end

  # Vérifie si l'utilisateur peut quitter
  #
  # @return [Boolean]
  def can_leave?
    member? && !owner?
  end
end
