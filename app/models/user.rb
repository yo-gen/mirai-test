class User

  include ActiveModel::Model
  
  attr_accessor :id, :name, :pincode

  validates :pincode, length: {in:5..6}

  def initialize(params = {})
      for i in 1..100000
        break if UserCache.new.get_user_by_id(i).nil?
      end
      @id = i
      self.name = params[:name]
      self.pincode = params[:pincode]
  end

end