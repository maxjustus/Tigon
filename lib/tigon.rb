class Hash
  def transform(options = {}, &blk)
    tr = HashTransformer.new(self, :exclusive => !!options[:exclusive])
    tr.instance_exec(&blk)
    tr.new_hash
  end
end

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

    replace_name = if newname
      newname
    else
      if name.is_a?(String)
        name
      else
        name.last
      end
    end

    if @current_value.is_a?(Hash) && (@current_value.key?(name) || (name.is_a?(Array) && @current_value.key?(name[0])))
      if name.is_a?(Array)
        current_val = furthest_value_from_hash(name, @current_value)
      else
        current_val = @current_value[name]
      end

      if block_given?
        transformer = self.class.new(current_val, options)
        v = transformer.instance_exec(&blk)

        #preserve values from previous calls to morph
        if v.is_a?(Hash) && @new_hash[replace_name]
          v = v.merge(@new_hash[replace_name])
        end

        @new_hash[replace_name] = v
      else
        @new_hash[replace_name] = current_val
      end
      @new_hash.delete(name) if newname
    end
    @new_hash
  end

  def furthest_value_from_hash(key_array, lookup_hash)
    key_array.reduce(lookup_hash) do |context, k|
      if context.is_a?(Hash)
        v = context[k]
      else
        context
      end
    end
  end
end
