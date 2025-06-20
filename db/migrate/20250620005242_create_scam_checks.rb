class CreateScamChecks < ActiveRecord::Migration[8.0]
  def change
    create_table :scam_checks do |t|
      t.text :description
      t.string :email
      t.string :url
      t.string :screenshot

      t.timestamps
    end
  end
end
