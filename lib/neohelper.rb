require "neohelper/version"

module Neohelper
  @neo = Neography::Rest.new

  module People
    def getPerson(id, props)
      Neography::Node.create_unique "person_index", "id", id, props
    end

    def putPersonInLocation(person, location)
      @neo.execute_query "
        START person=node({person_neo_id}), new_location=node({location_neo_id})
        MATCH person-[r:lives_in]->current_location
        WITH
          person, new_location, current_location, r
            WHERE
              current_location IS NOT NULL
              AND ID(current_location) <> ID(new_location)
                SET
                  current_location.outdated = timestamp()
                CREATE UNIQUE
                  person-[:lives_in]->new_location
        WITH
          person, new_location, current_location
            WHERE current_location IS NULL
              CREATE UNIQUE
                person-[:lives_in]->new_location
      ", :person_neo_id => person.neo_id.to_i, :location_neo_id => location.neo_id.to_i

      @neo.execute_query "
        START m=node({person_neo_id}), l=node({location_neo_id})
        CREATE UNIQUE
          m-[:lives_in]->l
      ", :person_neo_id => person.neo_id.to_i, :location_neo_id => location.neo_id.to_i
    end
  end

  module Geography
    def getLocation(zip, city, state)
      result = @neo.execute_query "
        MERGE (s:State {
          state: {state},
          name: {state}
        })
        CREATE UNIQUE
          s-[:city]->(c:City { city: {city}, name: {city}}) -[:zip]->(z:Zip { zip: {zip}, name: {zip}})
        RETURN z;
      ", :zip => zip.to_i, :city => city, :state => state
      return Neography::Node.load(result)
    end
  end

  module Time
    def getDatetime(datetime)
      result = @neo.execute_query "
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

  module Etc
    class << self
      def clear_database(neo)
        neo.execute_query "START r=rel(*) DELETE r;"
        neo.execute_query "START n=node(*) DELETE n;"
      end
    end
  end
end