class Thumbkit::Processor::Text < Thumbkit::Processor

  attr_accessor :path
  def initialize(path)
    @path = path
  end




  # Saving stuff for later.
  # mogrify -density 288 -background '#ccc' -fill '#333' -pointsize 18 -antialias -font Helvetica -format png -trim -resize %25 +repage -crop '200x200+10+10'  +repage test.txt

end
