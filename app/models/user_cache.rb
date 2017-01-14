class UserCache
  def get_user_by_id(id)
    Rails.cache.read(id)
  end

  def get_users_by_name(name)
    Rails.cache.read(name)
  end

  def get_users_in_pincode(pincode)
    users_in_pincode = Rails.cache.read("pin#{pincode}") #Add pin prefix to avoid cache keys conflicting with id.
    users_in_pincode.sort!{ |user1,user2| user1.name.downcase <=> user2.name.downcase } unless users_in_pincode.nil?
    users_in_pincode
  end

  # This is the only way to add user to the cache
  def add_user_to_cache(user)

    Rails.cache.fetch(user.id) {
      if get_users_by_name(user.name).nil?
        Rails.cache.write(user.name, [user])
      else
        Rails.cache.write(user.name, get_users_by_name(user.name).push(user))
      end

      if get_users_in_pincode(user.pincode).nil?
        Rails.cache.write("pin#{user.pincode}", [user])
      else
        Rails.cache.write("pin#{user.pincode}", get_users_in_pincode(user.pincode).push(user))
      end

      [user] #Return user to save by id key
    }

  end
end