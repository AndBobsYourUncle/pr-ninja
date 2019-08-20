class CreateJoinTablePullRequestsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :pull_requests_tagged_users do |t|
      t.references :user, foreign_key: true, index: true
      t.references :pull_request, foreign_key: true, index: true
      t.integer :status, default: 0, index: true
      t.integer :position, null: false
      t.timestamps
    end

    add_index :pull_requests_tagged_users, [:position]
  end
end
