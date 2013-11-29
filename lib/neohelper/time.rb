module Neohelper
  module Time
    class << self
      def getDatetime(datetime)
        result = Neography::Rest.new.execute_query "
          MERGE (y:Year {
              year: {year},
              name: {year}
          })
          CREATE UNIQUE
            y-[:month]->(month:Month { month: {month}, name: {month} })-[:day]->(day:Day { day: {day}, name: {day} })
          RETURN day;
        ", :day => datetime.day, :month => datetime.month, :year => datetime.year
        return Neography::Node.load(result)
      end
    end
  end
end
