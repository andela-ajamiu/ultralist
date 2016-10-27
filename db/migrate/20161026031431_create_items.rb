class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :name
      t.boolean :done
      t.references :bucketlist, foreign_key: true

      t.timestamps
    end
  end
end
