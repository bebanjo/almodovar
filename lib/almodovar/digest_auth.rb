module Almodovar
  class DigestAuth < Struct.new(:realm, :username, :password)
  end
end