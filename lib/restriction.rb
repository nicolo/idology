module IDology
  class Restriction
    include HappyMapper
    
    element :key, String
    element :message, String

    def global_watch_list_hit?
      key == 'global.watch.list'
    end
  end
end
