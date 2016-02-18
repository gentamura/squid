class CreateMoneyTransfers < ActiveRecord::Migration[5.0]
  def change
    create_table :money_transfers do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.integer :amount
      t.string :message

      t.timestamps
    end
    add_index :money_transfers, :sender_id
    add_index :money_transfers, :receiver_id
    add_index :money_transfers, [:sender_id, :receiver_id]
  end
end
