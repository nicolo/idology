module IDology
  class Result
    include HappyMapper
    tag 'results'
    element :key, String
    element :message, String
    
    def match?
      key == 'result.match' || key == 'result.match.restricted'
    end
  end
end
