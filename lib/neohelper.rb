require "neohelper/version"
require "neohelper/etc"
require "neohelper/geography"
require "neohelper/time"
require "neohelper/people"

module Neohelper
  @neo = Neography::Rest.new
end
