TARGETS=svggen.svg

# Run the program
svggen:; @eclipse -e "[main],run(single_shape,polygons,5,no_guides)"
swi:;    @pl -t "[main],run(single_shape,polygons,5,no_guides)"

# Remove the generated files
clean:; rm -rf $(TARGETS)
