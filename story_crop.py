#! /usr/bin/env python3

from PIL import Image

im = Image.open("pacman-parts.gif")

for x in range(8, 1319, 328):
    for y in range(8, 839, 208):
        scr = im.crop((x, y, x + 320, y + 200))
        fname = "story.%03x%03x.png" % (y, x)
        print("Writing `%s`." % fname)
        scr.save(fname)


