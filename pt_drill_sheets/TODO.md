TO DO
=====

- [ ] (2026-07-23) The GUI exposes the random number seed, which is just 
unnecessary, IMO. The people using the GUI won't care about particular seeds,
and the ones who do will be able to use the command line pipeline. So I want to
remove the Seed setting field in the GUI and replace it with a field that allows
you to set a number of different versions of the worksheet you want to make at 
once. There should also be a checkbox (unchecked) that allows the user to save 
them as separate files. If this is checked, then the app saves each worksheet 
as a separate pdf with the current name scheme (appending the seed). If the 
checkbox isn't checked, and the versions are all being saved as a single file, 
then 'n_versions' should be appended instead. (I'm also interested in your 
advice if you think there's a better way to make a default name.)


- [X] ] (2026-07-22) Design a header with appropriate fields for Timing and Counts.
Make sure all your worksheets use this header.

- [X] (2026-07-22) You've decided to got with 'Nimbus Sans', which can be bundled 
with the app. It looks pretty close to Helvetica.

Resume this session with:
claude --resume "FontsRuminations"

You are in the middle of trying to figure out what you should use
instead of Helvetica Neue. I don't really like Claude's recommendation
for a San-Serif font, but I'm not sure what's out there for a free
font I can bundle with the app.


