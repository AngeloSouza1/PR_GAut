class CreateSupercashConfigs < ActiveRecord::Migration[7.0]
  def change
# unless table_exists?(:supercash_configs)
    #   create_table :supercash_configs do |t|
    #     t.boolean :active, default: true
    #     t.boolean :capture, default: false
    #     t.string :base_url, null: false, default: "aa..33.22"
    #     t.datetime :deleted_at
    #     t.boolean :has_rate, default: false
    #     t.integer :installments
    #     t.string :name
    #     t.string :name_invoice
    #     t.decimal :rate, precision: 19, scale: 2
    #     t.string :secret_key
    #     t.string :public_key
    #     t.string :slug
    #     t.string :statement_descriptor
    #     t.references :client, null: true, foreign_key: true
    #     t.references :store, null: false, foreign_key: true

    #     t.timestamps
    #   end
    # end


    # unless column_exists?(:clients, :has_supercash)
    #   add_column :clients, :has_supercash, :boolean, default: false
    # end


    # unless Gateway.exists?(name: 'supercash')
    #   Gateway.create(
    #     version: '1',
    #     current: true,
    #     name: 'supercash',
    #     credit_card_service: 'Shield::Payment::CreditCard::CreatorV2',
    #     bank_slip_service: 'Shield::Payment::BankSlip::Creator',
    #     pix_service: 'Shield::Payment::Pix::CreatorV2',
    #     cancel_service: 'Shield::Payment::Cancel',
    #     supported_payment_kind: ['credit_card', 'pix']
    #   )
    # end
  end
end
