# Project 3 - ParsePics

ParsePics is a photo sharing app using Parse as its backend.

Time spent: 25 hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can sign up to create a new account using Parse authentication
- [X] User can log in and log out of his or her account
- [X] The current signed in user is persisted across app restarts
- [X] User can take a photo, add a caption, and post it to "Instagram"
- [X] User can view the last 20 posts submitted to "Instagram"
- [X] User can pull to refresh the last 20 posts submitted to "Instagram"
- [X] User can load more posts once he or she reaches the bottom of the feed using infinite Scrolling
- [X] User can tap a post to view post details, including timestamp and creation
- [X] User can use a tab bar to switch between all "Instagram" posts and posts published only by the user.

The following **optional** features are implemented:

- [X] Show the username and creation time for each post
- [X] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse.
- [ ] User Profiles:
   - [ ] Allow the logged in user to add a profile photo
   - [ ] Display the profile photo with each post
   - [ ] Tapping on a post's username or profile photo goes to that user's profile page
- [ ] User can comment on a post and see all comments for each post in the post details screen.
- [ ] User can like a post and see number of likes for each post in the post details screen.
- [X] Run your app on your phone and use the camera to take the photo


The following **additional** features are implemented:

- [X] Cancel button appears after selecting a photo to upload, which allows the user to delete the selected photo and select a new one.
- [X] AutoLayout
- [X] When the caption field is selected and the keyboard appears (and the opposite actions when the field is deselected and the keyboard disappears):
    - [X] The caption text field (and the rest of the screen) moves up above the keyboard
    - [X] The rest of the screen is grayed out, preventing the user from interacting with the image selector/image/cancel button
- [X] Detail view appears as an overlay (the main feed is still visible outside the boundaries of the image)

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1.
2.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/ftS7qli.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' /><img src = 'http://i.imgur.com/bycszZH.gif' width ='' /><img src = 'http://i.imgur.com/VriQ8dD.gif' width = '' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [Parse] (https://github.com/ParsePlatform/Parse-SDK-iOS-OSX) - Parse cloud platform library
- [Heroku] (https://dashboard.heroku.com/) - cloud application platform


## Notes

I spent a lot of time trying to get the feed view to pass data to the detail view, because the detail view's properties and subviews were inaccessible/nonexistent at the time I was passing data to them. Adjusting layouts and working with AutoLayout wasn't difficult, but was often time-consuming and frustrating. It was difficult to properly associate each cell's image view with a tap gesture recognizer.

## License

    Copyright 2016 Amy Xiong

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
