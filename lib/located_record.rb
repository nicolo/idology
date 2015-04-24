module IDology
  class LocatedRecord
    include HappyMapper
    tag 'located-record'
    element :uniquepersonid, Integer, :tag => 'uniquepersonid'
  end
end