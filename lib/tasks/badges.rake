namespace :badges do
  desc "Update all badge descriptions"
  task update_descriptions: :environment do
    badges_data = {
      # Level badges
      'Débutant' => "Bienvenue! Tu viens de rejoindre la communauté.",
      'Apprenti' => "Niveau 5 atteint. Tu progresses bien!",
      'Intermédiaire' => "Niveau 10! Tu maîtrises les bases de la plateforme.",
      'Avancé' => "Niveau 20. Tu es un membre avancé et expérimenté.",
      'Expert' => "Niveau 30! Ton expertise est reconnue par tous.",
      'Maître' => "Niveau 50. Tu es un maître incontesté!",
      'Légende' => "Niveau 100! Tu es une légende vivante de la plateforme.",

      # Project badges
      'Premier Projet' => "Tu as créé ton premier projet. C'est le début de l'aventure!",
      'Entrepreneur' => "5 projets créés! Tu as l'âme d'un entrepreneur.",
      'Chef de Projet' => "10 projets à ton actif. Tu es un vrai chef de projet!",
      'Collaborateur' => "Tu as participé à 5 projets. L'esprit d'équipe te définit.",
      'Team Player' => "10 projets en collaboration. Tu es un joueur d'équipe exemplaire!",
      'Vétéran' => "20 projets au total. Tu es un vétéran de la plateforme!",

      # Social badges
      'Première Publication' => "Tu as publié ton premier post. Ta voix compte!",
      'Blogueur' => "10 publications! Tu partages régulièrement tes idées.",
      'Influenceur' => "50 posts publiés. Tu es une vraie source d'inspiration!",
      'Commentateur' => "20 commentaires laissés. Tu aimes participer aux discussions.",
      'Populaire' => "10 personnes te suivent. Ta communauté grandit!",
      'Célébrité' => "50 followers! Tu es une célébrité sur la plateforme.",
      'Social' => "Tu suis 10 personnes. Tu aimes découvrir de nouveaux profils.",

      # Activity badges
      'Polyvalent' => "5 compétences ajoutées. Tu es polyvalent et curieux!",
      'Expert Multi-Domaines' => "10 compétences maîtrisées. Un vrai couteau suisse!",
      'Communicateur' => "50 messages envoyés. Tu aimes échanger avec les autres.",
      'Bavard' => "200 messages! La communication n'a pas de secret pour toi."
    }

    updated = 0
    badges_data.each do |name, description|
      badge = Badge.find_by(name: name)
      if badge
        badge.update!(description: description)
        puts "✓ #{name}: #{description}"
        updated += 1
      end
    end

    puts "\n#{updated} badges mis à jour!"
  end
end
