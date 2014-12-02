
all: graph assignments

graph: example_graph.dot
	circo -Tpng -o example_graph.png < example_graph.dot

assignments: example_assignments.txt

example_graph.dot: example_assignments.txt
	ruby ../make_dotfile.rb example_assignments.txt > example_graph.dot

example_assignments.txt: example_participants.txt
	ruby ../make_random_list.rb example_participants.txt > example_assignments.txt

send_email: example_assignments.txt
	ruby ../emailer.rb example_assignments.txt

clean:
	rm -f example_graph.dot
	rm -f example_graph.png
	rm -f example_assignments.txt
