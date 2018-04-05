class CreateMicroposts < ActiveRecord::Migration[5.1]
  def change
    create_table :microposts do |t|
      t.string :content
      t.integer :user_id
      t.string :image

      t.timestamps
    end
  end
end
