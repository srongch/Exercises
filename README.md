<p align="center">
 <img src="/Screenshot/iTunesArtwork.png" data-canonical-src="/Screenshot/iTunesArtwork.png" width="150" />
</p>

# Exercise App

 iOS Application implementing the user stories as follows.
## Installation
1. Run `pod install`
2. Open `Exercises.xcworkspace`
3. Run the project

## API endpoints used.

**User Story #1: List of Exercises : As a user, I want to see a paginated list of exercises.**
1. GET https://wger.de/api/v2/muscle/
2. GET https://wger.de/api/v2/exercisecategory/
3. GET https://wger.de/api/v2/exercise/
4. GET https://wger.de/api/v2/exerciseimage/
5. GET https://wger.de/api/v2/equipment/

**User Story #2: Exercise Detail : As a user, I want to be able to tap on an exercise in the list and open a detailed view.**

1. GET https://wger.de/api/v2/exerciseinfo/id/
2. GET https://wger.de/api/v2/exerciseimage/?exercise=id

**User Story #3: Search : As a user, I want to be able to search in the list of exercises.**

1. GET https://wger.de/api/v2/exercise/search/?term=bar

**User Story #4 - Filter : As a user, I want to be able to filter exercises by body part.**

1. GET https://wger.de/api/v2/exercise/?page=2&status=2&muscles=id

## Screenshots [iPad Ver.](docs/IPADDOC.md)
**User Story #1: List of Exercises : As a user, I want to see a paginated list of exercises.**

<img src="/Screenshot/iphone/iphone1.png" data-canonical-src="/Screenshot/iphone/iphone1.png" width="200" height="400" />

**User Story #2: Exercise Detail : As a user, I want to be able to tap on an exercise in the list and open a detailed view.**

 - Image Provided 
 <img src="/Screenshot/iphone/iphone2.png" data-canonical-src="/Screenshot/iphone/iphone2.png"  width="200" height="400" />
 
 - No Image Provided
 <img src="/Screenshot/iphone/iphone3.png" data-canonical-src="/Screenshot/iphone/iphone3.png" width="200" height="400" />

**User Story #3: Search : As a user, I want to be able to search in the list of exercises.**

<img src="/Screenshot/iphone/iphone6.png" data-canonical-src="/Screenshot/iphone/iphone6.png" width="200" height="400" />

**User Story #4 - Filter : As a user, I want to be able to filter exercises by body part.**

<img src="/Screenshot/iphone/iphone4.png" data-canonical-src="/Screenshot/iphone/iphone4.png"  width="200" height="400" />
<img src="/Screenshot/iphone/iphone5.png" data-canonical-src="/Screenshot/iphone/iphone5.png"  width="200" height="400" />

**User Story #5 - UI Feedback: As a user, I want to get feedback when the UI is loading**
1.  an activity indicator when the UI is loading data in the list or detail.

 <img src="/Screenshot/iphone/iphone9.png" data-canonical-src="/Screenshot/iphone/iphone9.png"  width="200" height="400" />
<img src="/Screenshot/iphone/iphone10.png" data-canonical-src="/Screenshot/iphone/iphone10.png"  width="200" height="400" />

2.  Show an error message if the API fails
   <img src="/Screenshot/iphone/iphone7.png" data-canonical-src="/Screenshot/iphone/iphone7.png" width="200" height="400" />
<img src="/Screenshot/iphone/iphone8.png" data-canonical-src="/Screenshot/iphone/iphone8.png" width="200" height="400" />
