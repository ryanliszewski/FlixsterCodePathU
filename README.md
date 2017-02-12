# Project 1 - *Flickster*

**Flickster** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **30** hours spent in total

## User Stories

The following **required** functionality is complete:

- [X] User can view a list of movies currently playing in theaters from The Movie Database.
- [X] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] User sees an error message when there's a networking error.
- [x] Movies are displayed using a CollectionView instead of a TableView.
- [x] User can search for a movie.
- [x] All images fade in as they are loading.
- [x] Customize the UI.
    - [x] Added an image assest for an icon to favorite a movie
    - [x] Added a rating bar the pod "Cosmos" that displays the rating of each movie out of five stars 
    - [x] Modified the third party pod "Cosomos" to not allow the user to change the rating, the appearce of the
        the stars, the color of the stars and how percise the stars are. 
    
The following **additional** features are implemented:
- [x] Added the Cocoa pod "Cosmos"
- [x] Added an icon as an image asset to favorite a movie 
- [x] Calculated a 5 star rating of each movie by retrieving "vote_average" from the Movie Database API and    
        dividing the api's rating by 2.
- [x] Displayed the calculated rating using the Cosomos pod. Modified the cosomos pod so the rating can't be change, modified the color and appearce of the stars, and change the stars setting's so they display a precise rating.'


- [x] List anything else that you can get done to improve the app functionality!

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. 
2. 

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/svbJW2X.gif' 'title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

## License

    Copyright [2017] [Ryan Liszewski]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

# Project 2 - *Flickster*

**Flickster** is a movies app displaying box office and top rental DVDs using [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **X** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can view movie details by tapping on a cell.
- [x] User can select from a tab bar for either **Now Playing** or **Top Rated** movies.
- [x] Customize the selection effect of the cell.

The following **optional** features are implemented:

- [x] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [x] Customize the navigation bar.
    - [x] Put the search bar in the navigation bar 
    - [x] Added a settings button 
    - [x] Customized color and look 

The following **additional** features are implemented:
- [x] Infinite scrolling for *Now Playing* and *Top Rated Movies*. The Movie Database only allows 20 movies per call so I implmented a functionality that calls the API again when the user scrolls and added the page parameter to the api call. 
- [x] AutoLayout for *Now Playing* and *Top Rated Movies* views, the movie detail view and launch screen.
- [x] App Icon and Launch screen 
- [x] Customized cell size in collection view 

- [ ] List anything else that you can get done to improve the app functionality!

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. 
2. 

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://imgur.com/svbJW2X.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

## License

Copyright [2017] [Ryan Liszewski]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
