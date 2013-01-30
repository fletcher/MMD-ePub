ALL : mmd.epub


# Package the files into the final epub
mmd.epub : epub
	rm -f mmd.epub
	zip -X0 mmd.epub mimetype
	zip -Xur9D mmd.epub *.xhtml *.opf *.ncx META-INF/* stylesheet.css images/*

# Ensure we have built the necessary files
epub : main.xhtml temp.xhtml main.html mimetype META-INF/container.xml container.opf toc.ncx


# Be sure to convert plain text to HTML
main.html : 
	mmd main.txt
	mmd main.md

# Process the HTML into suitable format for use in an epub
temp.xhtml : main.html
	xsltproc main.xslt main.html > temp.xhtml
	sed -i -e 1,3d temp.xhtml

# Make some changes so it works properly
main.xhtml : temp.xhtml
	echo "<!DOCTYPE html>" > main.xhtml
	echo "<html xmlns=\"http://www.w3.org/1999/xhtml\">" >> main.xhtml
	cat temp.xhtml >> main.xhtml

# Create the mimetype file
mimetype :
	echo "application/epub+zip\c" > mimetype

# Create the container XML file
META-INF/container.xml :
	mkdir -p META-INF
	echo "<?xml version=\"1.0\"?>" > META-INF/container.xml
	echo "<container version=\"1.0\" xmlns=\"urn:oasis:names:tc:opendocument:xmlns:container\">" >> META-INF/container.xml
	echo "	<rootfiles>" >> META-INF/container.xml
	echo "		<rootfile full-path=\"content.opf\" media-type=\"application/oebps-package+xml\"/>" >> META-INF/container.xml
	echo "	</rootfiles>" >> META-INF/container.xml
	echo "</container>" >> META-INF/container.xml

# Create the container package from the HTML
container.opf : 
	xsltproc content.xslt main.html > content.opf

# Create a table of contents from the HTML
toc.ncx : 
	xsltproc toc.xslt main.html > toc.ncx

# Remove files that we created
clean : 
	rm -f mimetype
	rm -f META-INF/container.xml
	rm -f container.opf
	rm -f content.opf
	rm -f toc.ncx
	rm -f main.xhtml
	rm -f temp.xhtml
	rm -f temp.xhtml-e
	rm -f mmd.epub
	rm -f main.html
