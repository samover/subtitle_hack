# subtitle_hack
This is a challenge I received through my brother (I think originally from Ironhack). 

Sometimes subtitles for those nifty divx files are not in sync with the movie. These subtitles are stored in an srt file that is layered over your video file (SubRip format).

Three tasks were set: 
1) Create a method that shifts the subtitles back or ahead by for ex. 500ms
2) Check the subtitle text against the user dictionary (/usr/share/dict/words on unix systems) and writes the potential typos to a textfile with the time on which they appear.
3) Check the subtitles against a list of censored words, substituting the swear words for CENSORED in a file called profanity.txt (puritans!).
