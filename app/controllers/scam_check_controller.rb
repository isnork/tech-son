class ScamCheckController < ApplicationController
  def index
    @scam_checks = ScamCheck.order(created_at: :desc).limit(10)
  end

  def create
    @scam_check = ScamCheck.new(scam_check_params)
    
    if @scam_check.save
      # Analyze with OpenAI in background
      AnalyzeScamCheckJob.perform_later(@scam_check.id)
      
      redirect_to scam_check_path(@scam_check), notice: 'Your scam check has been submitted successfully! Our AI security specialist is analyzing it now.'
    else
      @scam_checks = ScamCheck.order(created_at: :desc).limit(10)
      render :index, status: :unprocessable_entity
    end
  end

  def show
    @scam_check = ScamCheck.find(params[:id])
  end

  def update_details
    @scam_check = ScamCheck.find(params[:id])
    
    # Combine original description with additional details
    details = update_details_params
    
    # Build enhanced description
    enhanced_description = @scam_check.description
    
    if details[:additional_details].present?
      enhanced_description += "\n\nADDITIONAL DETAILS:\n#{details[:additional_details]}"
    end
    
    if details[:additional_emails].present?
      enhanced_description += "\n\nADDITIONAL EMAILS:\n#{details[:additional_emails]}"
    end
    
    if details[:additional_urls].present?
      enhanced_description += "\n\nADDITIONAL URLS:\n#{details[:additional_urls]}"
    end
    
    # Update the scam check with enhanced description
    if @scam_check.update(description: enhanced_description, analysis: nil)
      # Re-analyze with enhanced information
      AnalyzeScamCheckJob.perform_later(@scam_check.id)
      
      render json: { success: true, message: 'Additional details submitted successfully. Re-analyzing...' }
    else
      render json: { success: false, message: 'Error updating details' }, status: :unprocessable_entity
    end
  end

  def clear_history
    ScamCheck.delete_all
    redirect_to root_path, notice: 'History cleared.'
  end

  private

  def scam_check_params
    params.permit(:description, :email, :url, :screenshot)
  end

  def update_details_params
    params.permit(:additional_details, :additional_emails, :additional_urls)
  end
end
