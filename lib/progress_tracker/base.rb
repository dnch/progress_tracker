module ProgressTracker
  class Base

    # Enable the selection of a Redis connection
    class << self
      attr_accessor :redis_connection
    end

    # And default to using the established global var (yes, I know. Bad.)
    @redis_connection = $redis

    # Instance-level access to Redis (actually a Redis::Namespace)
    attr_reader :redis, :base_key

    # All sub-objects tracked with Base#track
    attr_reader :tracked_object_keys

    # The tracked object that this instance currently refers to
    attr_accessor :current_tracked_object

    # Just so we've always got values...
    DEFAULTS = { progress: 0, message: "" }

    def initialize(object_name, object_id = nil)
      @base_key = _ck(object_name, object_id)

      @redis = ::Redis::Namespace.new(@base_key, redis: ProgressTracker::Base.redis_connection)

      # initialize or fetch our tracked object keys from Redis, ensuring we at least have _base present
      @tracked_object_keys = Set.new(redis.smembers("tracked-object-keys").map(&:to_sym) << :_base)

      @current_tracked_object = :_base
    end

    # re-set every redis key that this instance is tracking
    def reset!
      ['tracked-object-keys', *tracked_object_keys.to_a].each { |key| redis.del key }

      @tracked_object_keys = Set.new([:_base])
      @current_tracked_object = :_base
    end

    # Build a compound key and store it for future reference
    def track(object_name, object_id = nil)
      new_key = _ck(object_name, object_id)

      redis.sadd "tracked-object-keys", new_key
      tracked_object_keys << new_key
    end

    # grab all the keys related to this set from redis
    def to_hash
      tracked_object_keys.inject({}) do |hash, key|
        hash.tap do |h|
          h[key] = DEFAULTS.merge(redis.hgetall(key).symbolize_keys)

          # Make sure :progress is always returned as an integer
          h[key][:progress] = h[key][:progress].to_i
        end
      end
    end


    # If a method is called that matches the name of a tracked object, return
    # a new instance of self with the @current_tracked_object set
    # to the correct key
    def method_missing(meth, *args)
      meth_key = _ck(meth, args.first)

      if tracked_object_keys.include?(meth_key)
        self.dup.tap do |t|
          t.current_tracked_object = meth_key
        end
      else
        raise NoMethodError
      end
    end


    def update(hsh)
      redis.hmset current_tracked_object, *hsh.to_a.flatten
    end

    # reset the currently trackd object
    def reset
      redis.del current_tracked_object
    end


    def progress(value)
      update progress: value.to_i
    end

    def message(msg)
      update message: msg
    end

    private

    # build a compound key in the format (name_id)
    def _ck(object_name, object_id = nil)
      if object_id
        :"#{object_name}_#{object_id}"
      else
        object_name.to_sym
      end
    end
  end
end
