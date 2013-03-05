Sequel.migration do
  change do
    # create_table(:requests) do
    #   # primary_key   :id
    #   # String        :field_1
    #   # Text          :field_2
    # end
    create_table(:identifiers) do
      primary_key :id
      String      :identifier
      String      :rooturl
    end
  end
end

# TODO: create migration file
# put all migrations in first file
# make sure migrations work
# rename class finders to use column name
# erase verify table exists (just make sure they do)
# look into/use group_and_count method in sorters
