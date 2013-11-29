module Neohelper
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
end
