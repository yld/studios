class CreateStudios < ActiveRecord::Migration[7.2]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    create_table :studios, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.date :opening

      t.timestamps
    end
  end
end
