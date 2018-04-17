class CreateHashtagsMicroposts < ActiveRecord::Migration[5.1]
  def change
    create_table :hashtags_microposts do |t|
      t.integer :hashtag_id
      t.integer :micropost_id

      t.timestamps
    end
  end
end
