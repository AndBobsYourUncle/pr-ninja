class CreateUserTags < ActiveRecord::Migration[5.2]
  def change
    create_table :user_tags do |t|
      t.references :user, foreign_key: true, index: true
      t.references :pull_request, foreign_key: true, index: true
      t.integer :status, default: 0, index: true
      t.integer :position, null: false
      t.timestamps
    end

    add_index :user_tags, [:position]
  end
end
