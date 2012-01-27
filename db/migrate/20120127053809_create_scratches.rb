class CreateScratches < ActiveRecord::Migration
  def change
    create_table :scratches do |t|
      t.binary :data
      t.string :application
      t.string :author

      t.timestamps
    end
  end
end
