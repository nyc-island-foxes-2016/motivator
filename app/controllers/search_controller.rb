class SearchController < ApplicationController
  def index
    @messages = Message.broadcast
    @results = []
    @results.push(search_users, search_charities, search_goals, search_milestones)
    @results = @results.select { |thing| thing.class == User || thing.class == Goal || thing.class == Milestone || thing.class == Charity }
  end

  private

  def search_users
    user_fields = [:id, :username, :email, :provider]
    user_fields.each do |field|
      if User.find_by(field => params[:q]) || User.find_by(field => params[:q].capitalize) || User.find_by(field => params[:q].upcase) || User.find_by(field => params[:q].downcase)
        @results.push if User.find_by(field => params[:q]) || @results.push(User.find_by(field => params[:q].capitalize)) || @results.push(User.find_by(field => params[:q].upcase)) || @results.push(User.find_by(field => params[:q].downcase))
      #add method later for partial matches
      end
    end
  end

  def search_charities
    charity_fields = [:name]
    charity_fields.each do |field|
      if Charity.find_by(field => params[:q])
      @results << Charity.find_by(field => params[:q])
      #need partial matches
      end
    end
  end

  def search_goals
    goal_fields = [:title, :description]
    goal_fields.each do |field|
      if Goal.find_by(field => params[:q])
      @results << Goal.find_by(field => params[:q])
      #need partial matches
      end
    end
  end

  def search_milestones
    milestone_fields = [:description]
    milestone_fields.each do |field|
      if Milestone.find_by(field => params[:q])
      @results << Charity.find_by(field => params[:q])
      #need partial matches
      end
    end
  end

  def search_deeper
    if params[:q].include?(" ")
      more_to_check = params[:q].split
    end
  end

end