# frozen_string_literal: true

# This migration and CreateVersionAssociations provide the necessary
# schema for tracking associations.
class AddTransactionIdColumnToVersions < ActiveRecord::Migration
  def self.up
    add_column :versions, :transaction_id, :integer
    add_index :versions, [:transaction_id]
  end

  def self.down
    remove_index :versions, [:transaction_id]
    remove_column :versions, :transaction_id
  end
end
