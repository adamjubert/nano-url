class CreateVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :visits do |t|
      t.integer :link_id, null: false

      t.timestamps
    end

    add_index :visits, :link_id
  end
end
