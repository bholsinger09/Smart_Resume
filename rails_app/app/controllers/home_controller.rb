class HomeController < ApplicationController
  def index
    @jobs = Job.active.recent.limit(10)
    @recent_matches = Match.includes(:job, :resume).order(created_at: :desc).limit(5)
  end
end
