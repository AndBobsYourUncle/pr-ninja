class CreateJoinTablePullRequestsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :pull_requests_tagged_users do |t|
      t.references :user, foreign_key: true, index: true
      t.references :pull_request, foreign_key: true, index: true
      t.string :status, :string, default: 'active', index: true
    end
  end
end
