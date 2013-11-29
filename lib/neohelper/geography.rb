module Neohelper
  module Geography
    class << self
      def getLocation(zip, city, state)
        result = Neography::Rest.new.execute_query "
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
  end
end
