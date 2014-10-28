module IDology
  class Restriction
    include HappyMapper
    
    element :key, String
    element :message, String

  end
end
