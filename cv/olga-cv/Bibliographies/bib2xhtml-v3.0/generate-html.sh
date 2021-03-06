#!/bin/sh

tmpfile="tmp.html"              # name of temporary file to use
outfile="bibliography.html"     # name of final bibliography output file
name="Olga Pearce" # name to highlight in the output

rm -f $outfile                  # Clean things up a bit first.
touch $outfile
id=1                            # Start the <ol> lists in the output at 1

#
# Usage:
#
#   bibliography <bibtex-file.bib> "Title"
#
# This will write out a section titled "Title" containing all
#
#
function bibliography {
    # use bib2xhtml and grep the ul list items away
    ./bib2xhtml -c -r -s empty -n "$name" $1 | awk '/<ul/,/<\/ul/' | grep -v '<ul\|<\ul' > $tmpfile

    # Make an ordered list, then put the list items from bib2xhtml in it
    cat >> $outfile <<EOF
<div style="margin-left:10px;"><b><i>$2</i></b></div>
<p>
<ol start="$id">
EOF
    cat $tmpfile >> $outfile
    cat >> $outfile <<EOF
</ol>
<p>
EOF
    # Add number of list items in the temp file to id, so the list
    # starts at the right number.
    id=$(expr $id + $(grep '<li>' $tmpfile | wc -l))
}

#
# Call the bibliography function for each section you want in the output here.
#
bibliography Papers.bib    "Refereed Publications in Conferences and Journals"
bibliography Workshops.bib "Unrefereed Publicagtions and Technical Reports"
bibliography Posters.bib   "Posters and Presentations"

# clean up the temp file.
rm $tmpfile
