class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy, :match_resume]
  
  def index
    @jobs = Job.active.recent.limit(50)
  end
  
  def show
    @matches = @job.matches.includes(:resume).by_score.limit(10)
  end
  
  def new
    @job = Job.new
  end
  
  def create
    @job = Job.new(job_params)
    
    if @job.save
      @job.extract_required_skills
      redirect_to @job, notice: 'Job was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @job.update(job_params)
      @job.extract_required_skills
      redirect_to @job, notice: 'Job was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @job.destroy
    redirect_to jobs_url, notice: 'Job was successfully deleted.'
  end
  
  def match_resume
    @resume = Resume.find(params[:resume_id])
    
    @match = Match.find_or_initialize_by(job: @job, resume: @resume)
    
    if @match.new_record?
      if @match.save
        redirect_to match_path(@match), notice: 'Match created successfully!'
      else
        redirect_to @job, alert: 'Could not create match.'
      end
    else
      redirect_to match_path(@match), notice: 'Match already exists.'
    end
  end
  
  private
  
  def set_job
    @job = Job.find(params[:id])
  end
  
  def job_params
    params.require(:job).permit(
      :title, :company, :description, :requirements,
      :location, :employment_type, :salary_min, :salary_max, :active
    )
  end
end
