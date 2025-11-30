class ResumesController < ApplicationController
  before_action :set_resume, only: [:show, :destroy, :analysis]
  
  def index
    @resumes = Resume.order(created_at: :desc).limit(50)
  end
  
  def show
    @matches = @resume.matches.includes(:job).by_score.limit(10)
  end
  
  def create
    @resume = Resume.new(resume_params)
    
    if params[:resume][:file].present?
      @resume.file.attach(params[:resume][:file])
      @resume.filename = params[:resume][:file].original_filename
      @resume.content_type = params[:resume][:file].content_type
    end
    
    if @resume.save
      # Extract skills will happen in after_create callback
      redirect_to resume_path(@resume), notice: 'Resume uploaded successfully! Processing skills...'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def destroy
    @resume.destroy
    redirect_to resumes_url, notice: 'Resume was successfully deleted.'
  end
  
  def analysis
    # Detailed analysis view
    @skills = @resume.skills
    @potential_jobs = find_potential_matches
  end
  
  private
  
  def set_resume
    @resume = Resume.find(params[:id])
  end
  
  def resume_params
    params.require(:resume).permit(:filename)
  end
  
  def find_potential_matches
    return [] if @resume.skill_names.empty?
    
    Job.active.includes(:skills).select do |job|
      common_skills = (@resume.skill_names & job.skill_names)
      common_skills.size >= 1
    end.sort_by do |job|
      -(@resume.skill_names & job.skill_names).size
    end.first(5)
  end
end
