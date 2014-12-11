class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true

# Add in user authentication with bCrypt

include BCrypt

def password
  @password ||= Password.new(password_hash) if password_hash
end

def password=(new_password)
  @password = Password.create(new_password)
  self.password_hash = @password
end

def authenticate(password)
  self.password == password
end

end
