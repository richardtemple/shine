class AddAddresses < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :code, size: 2, null: false
      t.string :name, null: false
    end

    create_table :addresses do |t|
      t.references :state,  null: false
      t.string     :street, null: false
      t.string     :city,   null: false
      t.string     :zipcode
    end

    create_table :customers_billing_addresses do |t|
      t.references :customer, null: false
      t.references :address, null: false
    end

    create_table :customers_shipping_addresses do |t|
      t.references :customer, null: false
      t.references :address,  null: false
      t.boolean    :primary
    end
  end
end
