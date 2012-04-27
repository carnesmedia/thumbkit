require 'delegate'

class Thumbkit::Defaults < DelegateClass(Hash)
  @@merge_proc = proc { |key, left, right|
    Hash === left && Hash === right ? left.merge!(right, &@@merge_proc) : right
  }

  def initialize(hash)
    __setobj__ hash
  end

  def merge(other)
    Thumbkit::Defaults::new(__getobj__.dup.merge!(other, &@@merge_proc))
  end
end
