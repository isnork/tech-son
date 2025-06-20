class AnalyzeScamCheckJob < ApplicationJob
  queue_as :default

  def perform(scam_check_id)
    scam_check = ScamCheck.find(scam_check_id)
    
    # Skip if already analyzed
    return if scam_check.analysis.present?
    
    # Get OpenAI analysis
    openai_service = OpenaiService.new
    analysis = openai_service.analyze_scam_check(scam_check)
    
    # Update the scam check with the analysis
    scam_check.update(analysis: analysis)
  rescue => e
    Rails.logger.error "Failed to analyze scam check #{scam_check_id}: #{e.message}"
    # You could also send an email notification here
  end
end 