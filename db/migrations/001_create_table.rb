Sequel.migration do
  change do
    create_table :identifiers do
      primary_key :id
      String      :identifier
      String      :rooturl
    end

    create_table :payloads do
      primary_key :id
      foreign_key :client_id
      foreign_key :event_id
      String      :user_agent
      String      :url
      String      :path
      DateTime    :requested_at
      Integer     :responded_in
      String      :referred_by
      String      :request_type
      String      :resolution_width
      String      :resolution_height
      String      :ip
    end

    create_table :events do
      primary_key :id
      String      :name
      DateTime    :created_at
    end

    create_table :campaigns do
      primary_key :id
      String      :name
      String      :identifier
      DateTime    :created_at
    end
  end
end

# TODO: 
# analytics class?
# look into/use group_and_count method in sorters
