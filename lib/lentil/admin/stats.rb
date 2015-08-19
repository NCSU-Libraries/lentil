ActiveAdmin.register_page "Stats" do
  content do
    render partial: 'stats'
  end

  controller do
    def index
      stats = []

      images = Lentil::Image.all
      battles = Lentil::Battle.all.count
      like_votes = Lentil::LikeVote.all.count
      users = Lentil::User.all.count
      tags = Lentil::Tag.all.count
      taggings = Lentil::Tagging.all.count

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
