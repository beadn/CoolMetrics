class AddIndexToMetricsName < ActiveRecord::Migration[7.1]
  def change
    add_index :metrics, :name
  end
end
