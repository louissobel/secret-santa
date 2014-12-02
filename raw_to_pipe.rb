# Command line filter, maybe useful
#
# Input line:
#  Ben Bitdiddle <diddle@mit.edu>
# Output line:
#  Ben Bitdiddle|diddle@mit.edu

STDIN.each do |line|
  line = line.chomp
  next unless line.length > 0

  line =~ /(.+?) \<(.+?)\>/
  print "#{$1}|#{$2}"
end
