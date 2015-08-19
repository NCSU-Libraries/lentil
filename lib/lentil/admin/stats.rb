ActiveAdmin.register_page "Stats" do
  content do
    render partial: 'stats'
  end

  controller do
    def index
      stats = []

      stats << {name: 'Number of Images', value: Lentil::Image.all.count}
      stats << {name: 'Number of Battles', value: Lentil::Battle.all.count}
      stats << {name: 'Number of Like Votes', value: Lentil::LikeVote.all.count}
      stats << {name: 'Number of Users', value: Lentil::User.all.count}
      stats << {name: 'Number of Donor Agreements', value: calc_donor_agreements}
      stats << {name: 'Number of Tags', value: Lentil::Tag.all.count}
      @stats = stats
    end

    def calc_donor_agreements
      images = Lentil::Image.all
      submitted_agreements = images.map(&:donor_agreement_submitted_date).compact.count
      rejected_agreements = images.map(&:donor_agreement_rejected).compact.count
      submitted_agreements - rejected_agreements
    end
  end
end
