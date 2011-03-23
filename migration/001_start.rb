Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      Bignum :tw_id, :unique => true
      String :name
      String :screen_name
      String :profile_image_url
    end
    
    create_table(:tweets) do
      primary_key :id
      foreign_key :user_id, :users
      Bignum :tw_id, :unique => true
      String :text
      Time :created_at
    end
  end
end
