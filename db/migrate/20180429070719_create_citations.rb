class CreateCitations < ActiveRecord::Migration[5.1]
  def change
    create_table :citations do |t|
      t.integer :repost_id
      t.integer :source_id

      t.timestamps
    end
  end
end
