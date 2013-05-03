class AddPairingLongDesc < ActiveRecord::Migration
  def change
    add_column :pairing_translations, :long_description, :text, :limit => 16777215
  end
end
