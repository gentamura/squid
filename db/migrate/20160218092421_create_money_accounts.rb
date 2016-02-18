class CreateMoneyAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :money_accounts do |t|
      t.references :user, foreign_key: true
      t.integer :balance, default: 0

      t.timestamps
    end
  end
end
