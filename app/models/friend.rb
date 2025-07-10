class Friend < ExternalRecord
  self.table_name = "cytonic_friends"
  self.primary_key = "uuid"

  def friends
    JSON.parse(super || "[]")
  end
end
