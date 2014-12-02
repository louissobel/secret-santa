# ARGV[0] is list of:
#   name|email
# Will output a random cycle, eacho line being a
#   {name|email}SEPARATOR{name|email}

SEPERATOR = "\t"

list = []

File.readlines(ARGV[0]).each do |line|
  line.chomp!
  list.push line
end


shuffled = list.shuffle

shuffled.zip(shuffled.rotate).each do |participant, assigned_to|
  puts "#{participant}#{SEPERATOR}#{assigned_to}"
end
