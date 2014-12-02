# sourcefile should be a bunch of lines with
# {giver}SEPARATOR{receiver}
#
# This will output a dotfile with the assignments

sourcefile = ARGV[0]
SEPARATOR = "\t"


gives_to_hash = {}

File.readlines(sourcefile).each do |line|
  line.chomp!
  giver, gives_to = line.split(SEPARATOR).map{ |pe| pe.split('|')[0] }
  gives_to_hash[giver] = gives_to
end

### a nice little two coloring algo
colors = {}
first_color='green'
second_color='red'
gives_to_hash.each_key do |k|
  if not colors.key? k
    colors[k] = first_color
    current = gives_to_hash[k]
    color = second_color
    while current != k && !current.nil? do
      colors[current] = color
      color = (color == first_color ? second_color : first_color)
      current = gives_to_hash[current]
    end
  end
end
  
all_nodes = (gives_to_hash.keys + gives_to_hash.values).uniq

puts "digraph gifts {"

puts <<HEADER
graph [overlap=compress]
HEADER

name_node_hash = {}
all_nodes.each_with_index do |k, i|
  node = "n#{i}"
  name_node_hash[k] = node
  puts "#{node}\t[label=\"#{k}\",style=filled,color=\"#{colors[k]}\"]"
end

edges = {}
gives_to_hash.each do |k, v|
  edges[name_node_hash[k]] = name_node_hash[v]
end



edges.each do |k, v|
  puts "#{k} -> #{v}" if v
end


puts "}"
