# frozen_string_literal: true

# Concern pour les patterns d'autorisation communs
#
# Usage:
#   class PostsController < ApplicationController
#     include Authorizable
#     before_action :set_post
#     before_action -> { authorize_owner!(@post, :user) }, only: [:edit, :update, :destroy]
#   end
#
module Authorizable
  extend ActiveSupport::Concern

  private

  # Vérifie que l'utilisateur courant est le propriétaire de la ressource
  #
  # @param resource [ApplicationRecord] La ressource à vérifier
  # @param owner_method [Symbol] Le nom de la méthode pour obtenir le propriétaire (default: :owner)
  # @param redirect_path [String, nil] Le chemin de redirection (default: la ressource)
  # @param message [String] Le message d'erreur
  def authorize_owner!(resource, owner_method = :owner, redirect_path: nil, message: nil)
    owner = resource.public_send(owner_method)
    return true if owner == current_user

    message ||= "Vous n'êtes pas autorisé à effectuer cette action."
    redirect_path ||= resource
    redirect_to redirect_path, alert: message
    false
  end

  # Vérifie que l'utilisateur courant est membre du projet
  #
  # @param project [Project] Le projet à vérifier
  # @param redirect_path [String, nil] Le chemin de redirection
  # @param message [String] Le message d'erreur
  def authorize_member!(project, redirect_path: nil, message: nil)
    return true if project.members.include?(current_user) || project.owner == current_user

    message ||= "Vous devez être membre de ce projet pour effectuer cette action."
    redirect_path ||= project
    redirect_to redirect_path, alert: message
    false
  end

  # Vérifie que l'utilisateur courant peut accéder à la ressource
  # (soit propriétaire, soit membre)
  #
  # @param project [Project] Le projet à vérifier
  def authorize_project_access!(project, redirect_path: nil, message: nil)
    return true if project.visibility == 'public'

    authorize_member!(project, redirect_path: redirect_path, message: message)
  end
end
