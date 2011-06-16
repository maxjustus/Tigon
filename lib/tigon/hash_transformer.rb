module Tigon
  class HashTransformer
    def initialize(hash_or_value, options = {})
      @options = options
      @current_value = hash_or_value
      if @current_value.is_a?(Hash) && !options[:exclusive]
        @new_hash = @current_value
      else
        @new_hash = {}
      end
    end

    def new_hash
      @new_hash
    end

    def value
      @current_value
    end

    def keep(name)
      @new_hash[name] = @current_value[name]
      @new_hash
    end

    def morph(name, newname = false, options = false, &blk)
      options ||= @options

      replacement_key = if newname
        newname
      else
        if name.is_a?(String)
          name
        else
          name.last #assumes an array was passed
        end
      end

      if @current_value.is_a?(Hash) && (@current_value.key?(name) || (name.is_a?(Array) && @current_value.key?(name[0])))
        if name.is_a?(Array)
          current_val = furthest_value_from_hash(name, @current_value)
        else
          current_val = @current_value[name]
        end

        if block_given?
          @new_hash[replacement_key] = nest_tranformation(current_val, replacement_key, options, blk)
        else
          @new_hash[replacement_key] = current_val
        end
        @new_hash.delete(name) if newname
      end
      @new_hash
    end

    def nest_tranformation(val, replacement_key, options, blk)
        transformer = self.class.new(val, options)
        transformed_val = transformer.instance_exec(&blk)

        #preserve values from previous calls to morph
        if transformed_val.is_a?(Hash) && @new_hash[replacement_key]
          transformed_val = transformed_val.merge(@new_hash[replacement_key])
        end
        transformed_val
    end

    def furthest_value_from_hash(key_array, lookup_hash)
      key_array.reduce(lookup_hash) do |context, k|
        if context.is_a?(Hash)
          context[k]
        else
          context
        end
      end
    end
  end
end
