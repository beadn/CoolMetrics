class CreateMetrics < ActiveRecord::Migration[7.1]
  def change
    create_table :metrics do |t|
      t.string :name
      t.decimal :value
      t.datetime :timestamp

      t.timestamps
    end
  end
end
