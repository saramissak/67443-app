# TuneIn
Our app provides a platform for music listeners to post music in order to discover and share songs amongst their friends. Similar to that of an existing app, BeReal, users are expected to post a song of the day and users can interact with each other’s posts by liking, commenting, sharing a song, and listening to the song if they have a Spotify premium account. When posting, the users can add comments and moods to the post.

In addition, users can log in with their Spotify account and create and edit their own TuneIn profile, see their notifications, and remove friends. 

# Testing
Spartan is inaccessible when testing so the functions using Spartan were not tested. On the other hand, the rest of our view models have been tested.

# Possible errors you may get
### ”*/67443-app/TuneIn/Pods/Target Support Files/Alamofire/Alamofire-Info.plist'
If you get something similar to: ”*/67443-app/TuneIn/Pods/Target Support Files/Alamofire/Alamofire-Info.plist'. Did you forget to declare this file as an output of a script phase or custom build rule which produces it?

Go to the TuneIn folder and run “pod install” 

### Google.plist Missing
There is a good chance when you pull and try to run you will get an error message saying that the GoogleService-Info.plist. This message is because there is a file not included in the repo. This file has been sent to both Prof H and Kenny on Slack. 
