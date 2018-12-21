class CreateLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :links do |t|
      t.string :long_link, null: false
      t.string :short_link
      t.string :title

      t.timestamps
    end

    add_index :links, :long_link, unique: true
    add_index :links, :short_link, unique: true
  end
end
