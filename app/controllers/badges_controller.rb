# frozen_string_literal: true

class BadgesController < ApplicationController
  before_action :authenticate_user!

  def index
    @all_badges = Badge.order(:xp_required).group_by(&:category)
    @user_badge_ids = current_user.badges.pluck(:id)
    @user_xp = current_user.experience_points

    # Catégories avec labels
    @categories = {
      "progression" => { label: "Progression", icon: "target", color: "primary" },
      "projects" => { label: "Projets", icon: "rocket", color: "accent" },
      "team" => { label: "Équipe", icon: "users", color: "pink" },
      "social" => { label: "Social", icon: "message-circle", color: "blue" },
      "skills" => { label: "Skills", icon: "wrench", color: "orange" },
      "special" => { label: "Spécial", icon: "star", color: "yellow" },
      "activity" => { label: "Activité", icon: "calendar", color: "green" }
    }

    # Stats
    @total_badges = Badge.count
    @unlocked_badges = @user_badge_ids.count
    @completion_percentage = (@unlocked_badges.to_f / @total_badges * 100).round
  end
end
