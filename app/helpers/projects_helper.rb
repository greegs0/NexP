module ProjectsHelper
  def translate_status(status)
    translations = {
      'draft' => 'Brouillon',
      'open' => 'Ouvert',
      'in_progress' => 'En cours',
      'completed' => 'Terminé',
      'archived' => 'Archivé'
    }
    translations[status] || status
  end
end
