Title:	MultiMarkdown to ePub Converter  
Author:	Fletcher T. Penney  
Date:	2012-11-07  
Base Header Level:	2  

# Introduction #

This tool allows you to convert a MultiMarkdown document into a basic ePub with little fuss.


# How to Use It #

It requires a bit of terminal know-how, but isn't too hard to use:

	> copy ../foo.txt main.txt
	> copy ../images/*.png images/
	> make

Basically, you:

* move your MultiMarkdown file into this directory and name it `main.txt` or `main.md`

* You then move any necessary images into the `images` folder (be sure that the links to these images are properly prefaced, e.g. `![foo](images/bar.png)`)

* If desired, you can modify the CSS (`stylesheet.css`), or just stick with the default

* run `make` at the command line, and you should now have a file named `mmd.epub`

# Limitations #

I have not done extensive testing with this, specifically:

* I have opened the ePubs in iBooks on iOS 6 devices without problems.

* The generated ePubs are in ePub version 3, using HTML 5 as the main source.  You can modify this to generate version 2 ePubs, but would then need to use XHTML 1.1. 

* I have not tried to open these ePubs with other devices/apps.


I welcome feedback/improvements to help make this more reliable.  Once it's stable, I might look into a way to make this more user-friendly.
