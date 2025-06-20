class AddAnalysisToScamChecks < ActiveRecord::Migration[8.0]
  def change
    add_column :scam_checks, :analysis, :text
  end
end
