ALL : test.epub


test.epub : epub
	rm -f ../test.epub
	zip -X0 ../test.epub mimetype
	zip -Xur9D ../test.epub *.xhtml *.opf *.ncx META-INF/* stylesheet.css images/*

epub : main.xhtml temp.xhtml main.html mimetype META-INF/container.xml container.opf toc.ncx

main.html : 
	mmd main.txt
	mmd main.md

temp.xhtml : main.html
	xsltproc main.xslt main.html > temp.xhtml
	sed -i -e 1,3d temp.xhtml
#	perl -pi -e 's/^<html xmlns:html.*$/<html xmlns="http:\/\/www.w3.org\/1999\/xhtml">/' temp.xhtml
#	cp main.html main.xhtml

main.xhtml : temp.xhtml
	echo "<!DOCTYPE html>" > main.xhtml
	echo "<html xmlns=\"http://www.w3.org/1999/xhtml\">" >> main.xhtml
	cat temp.xhtml >> main.xhtml

mimetype :
	echo "application/epub+zip\c" > mimetype

META-INF/container.xml :
	mkdir -p META-INF
	echo "<?xml version=\"1.0\"?>" > META-INF/container.xml
	echo "<container version=\"1.0\" xmlns=\"urn:oasis:names:tc:opendocument:xmlns:container\">" >> META-INF/container.xml
	echo "	<rootfiles>" >> META-INF/container.xml
	echo "		<rootfile full-path=\"content.opf\" media-type=\"application/oebps-package+xml\"/>" >> META-INF/container.xml
	echo "	</rootfiles>" >> META-INF/container.xml
	echo "</container>" >> META-INF/container.xml

container.opf : 
	xsltproc content.xslt main.html > content.opf

toc.ncx : 
	xsltproc toc.xslt main.html > toc.ncx

clean : 
	rm -f mimetype
	rm -f META-INF/container.xml
	rm -f container.opf
	rm -f toc.ncx
	rm -f main.xhtml
	rm -f temp.xhtml
	rm -f temp.xhtml-e

