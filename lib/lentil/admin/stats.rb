ActiveAdmin.register_page "Stats" do
  content do
    render partial: 'stats'
  end

  controller do
    def index
      stats = []

      images = Lentil::Image.all
      battles = Lentil::Battle.count
      like_votes = Lentil::LikeVote.count
      users = Lentil::User.count
      tags = Lentil::Tag.count
      taggings = Lentil::Tagging.count

      submitted_agreements = images.map(&:donor_agreement_submitted_date).compact.count
      rejected_agreements = images.map(&:donor_agreement_rejected).compact.count
      accepted_aggrements = submitted_agreements - rejected_agreements

      stats << {name: 'Number of Images', value: images.count}
      stats << {name: 'Number of Battles', value: battles}
      stats << {name: 'Number of Like Votes', value: like_votes}
      stats << {name: 'Number of Users', value: users}
      stats << {name: 'Number of Submitted Donor Agreements', value: submitted_agreements}
      stats << {name: 'Number of Accepted Donor Agreements (implicit)', value: accepted_aggrements}
      stats << {name: 'Number of Rejected Donor Agreements (explicit)', value: rejected_agreements}
      stats << {name: 'Number of Unique Tags', value: tags}
      stats << {name: 'Number of Taggings', value: taggings}

      @stats = stats
    end
  end
end
