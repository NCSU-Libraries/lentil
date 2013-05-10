module Lentil
  module ThisorthatHelper
    def battle_link_name
      if params[:action] == "battle"
        "Battle Leaders"
      else params[:action] == "battle_leaders"
        "Battle"
      end
    end

    def battle_link_action
      if params[:action] == "battle"
        :battle_leaders
      else params[:action] == "battle_leaders"
        :battle
      end
    end
  end
end