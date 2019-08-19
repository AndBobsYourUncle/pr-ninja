class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :slack_scopes, array: true, default: []
      t.string :slack_id, index: true
      t.string :slack_team_id
      t.string :slack_access_token
      t.timestamps
    end
  end
end
