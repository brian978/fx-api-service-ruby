class CreateRates < ActiveRecord::Migration[7.0]
  def change
    create_table :rates do |t|
      t.date :date, null: false
      t.float :value, null: false
      t.float :multiplier, null: true

      t.timestamps

      t.belongs_to :currency, foreign_key: true
    end

    add_reference :rates, :ref_currency, foreign_key: { to_table: :currencies }, null: false

    add_index :rates, [:created_at, :currency_id], unique: true, name: 'uq_rate_entry'
  end
end
