class CreateJoinTablePullRequestsUsers < ActiveRecord::Migration[5.2]
  def change
    create_join_table :pull_requests, :users do |t|
      t.index [:pull_request_id, :user_id]
      t.index [:user_id, :pull_request_id]
    end
  end
end
