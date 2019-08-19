class CreatePullRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :pull_requests do |t|
      t.references :user, foreign_key: true, index: true
      t.string :description
      t.string :link, index: true
      t.timestamps
    end
  end
end
