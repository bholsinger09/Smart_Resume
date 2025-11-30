class MatchesController < ApplicationController
  before_action :set_match, only: [:show]
  
  def index
    @matches = Match.includes(:job, :resume).by_score.page(params[:page])
  end
  
  def show
    # Display detailed match information
  end
  
  def create
    @resume = Resume.find(params[:resume_id])
    @job = Job.find(params[:job_id])
    
    @match = Match.find_or_initialize_by(resume: @resume, job: @job)
    
    if @match.new_record?
      if @match.save
        respond_to do |format|
          format.html { redirect_to @match, notice: 'Match created successfully!' }
          format.json { render json: @match, status: :created }
        end
      else
        respond_to do |format|
          format.html { redirect_back fallback_location: root_path, alert: 'Could not create match.' }
          format.json { render json: @match.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to @match, notice: 'Match already exists.' }
        format.json { render json: @match }
      end
    end
  end
  
  private
  
  def set_match
    @match = Match.includes(:job, :resume).find(params[:id])
  end
end
