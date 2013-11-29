module Neohelper
  module Etc
    class << self
      def clear_database(neo)
        neo.execute_query "START r=rel(*) DELETE r;"
        neo.execute_query "START n=node(*) DELETE n;"
      end
    end
  end
end
