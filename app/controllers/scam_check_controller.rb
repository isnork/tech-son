class ScamCheckController < ApplicationController
  def index
    @scam_checks = ScamCheck.order(created_at: :desc).limit(10)
  end

  def create
    @scam_check = ScamCheck.new(scam_check_params)
    
    if @scam_check.save
      redirect_to root_path, notice: 'Your scam check has been submitted successfully!'
    else
      @scam_checks = ScamCheck.order(created_at: :desc).limit(10)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def scam_check_params
    params.permit(:description, :email, :url, :screenshot)
  end
end
