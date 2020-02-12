class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  private

  def execute(*cmds)
    `#{cmds.join(' ')}`
  end

  def aggressive_deep_symbolize_keys(maybe)
    return maybe.deep_symbolize_keys if maybe.respond_to?(:deep_symbolize_keys)
    return maybe.map { |i| aggressive_deep_symbolize_keys(i) } if maybe.respond_to?(:each)

    maybe
  end

  def hash_find(obj, key)
    if obj.respond_to?(:key?) && obj.key?(key)
      obj[key]
    elsif obj.respond_to?(:each)
      r = nil
      obj.find{ |*a| r = hash_find(a.last,key) }
      r
    end
  end

  def hash_find_dig(obj, *keys)
    keys.each do |k|
      obj = hash_find(obj, k)
      return nil if obj.nil?
    end

    obj
  end
end
