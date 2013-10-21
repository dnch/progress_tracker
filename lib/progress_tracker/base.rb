module ProgressTracker
  class Base

    # which connection are we using?
    class << self
      attr_accessor :redis
    end
    # default to the global variable (yes, bad, I know.)
    @redis = $redis


    def initialize(namespace)
    end
  end
end
