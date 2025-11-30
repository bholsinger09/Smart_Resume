class JobMatchingService
  attr_reader :resume, :job
  
  def initialize(resume, job)
    @resume = resume
    @job = job
  end
  
  def calculate_match
    resume_skills = normalize_skills(resume.skill_names)
    job_skills = normalize_skills(job.skill_names)
    
    matched = resume_skills & job_skills
    missing = job_skills - resume_skills
    extra = resume_skills - job_skills
    
    score = calculate_score(matched.size, job_skills.size, missing.size)
    recommendations = generate_recommendations(matched, missing, extra)
    
    {
      score: score,
      matched_skills: matched,
      missing_skills: missing,
      extra_skills: extra,
      recommendations: recommendations
    }
  end
  
  private
  
  def normalize_skills(skills)
    skills.map { |s| s.downcase.strip }.uniq.sort
  end
  
  def calculate_score(matched_count, total_required, missing_count)
    return 0.0 if total_required.zero?
    
    # Base score from matched skills
    base_score = (matched_count.to_f / total_required * 100).round(2)
    
    # Penalty for missing required skills
    penalty = (missing_count.to_f / total_required * 20).round(2)
    
    # Ensure score is between 0 and 100
    final_score = [base_score - penalty, 0].max
    [final_score, 100].min
  end
  
  def generate_recommendations(matched, missing, extra)
    recommendations = []
    
    if matched.any?
      recommendations << "Great match! You have #{matched.size} required skills: #{matched.first(5).join(', ')}#{matched.size > 5 ? ', and more' : ''}."
    end
    
    if missing.any?
      if missing.size <= 3
        recommendations << "Consider learning: #{missing.join(', ')} to strengthen your application."
      else
        recommendations << "You're missing #{missing.size} skills. Focus on: #{missing.first(3).join(', ')}."
      end
    else
      recommendations << "Excellent! You have all the required skills for this position."
    end
    
    if extra.any? && extra.size > 3
      recommendations << "You also have #{extra.size} additional skills that could be valuable."
    end
    
    # Match level guidance
    score = calculate_score(matched.size, (matched + missing).size, missing.size)
    case score
    when 90..100
      recommendations << "Outstanding match! Apply with confidence."
    when 70..89
      recommendations << "Strong candidate. Highlight your matching skills in your application."
    when 50..69
      recommendations << "Decent fit. Consider upskilling in missing areas before applying."
    else
      recommendations << "This role may be a stretch. Focus on developing key missing skills."
    end
    
    recommendations.join(' ')
  end
end
