class Hash
  def transform(options = {}, &blk)
    tr = Tigon::HashTransformer.new(self, :exclusive => !!options[:exclusive])
    tr.instance_exec(&blk)
    tr.new_hash
  end
end
