require 'delegate'

class Thumbkit::Options < DelegateClass(Hash)
  @@merge_proc = proc { |key, left, right|
    Hash === left && Hash === right ? left.merge(right, &@@merge_proc) : right
  }

  def initialize(hash)
    __setobj__ hash
  end

  def merge(other)
    Thumbkit::Options::new(__getobj__.merge(other, &@@merge_proc))
  end
end
