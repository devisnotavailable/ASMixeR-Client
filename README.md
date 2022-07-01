# ASMixeR

**ASMixeR** is a free and open-source Flutter application for ASMR listening.

It mixes ASMR sounds based on the categories you select + helps you find new ASMR videos and creators.

## Screenshots
<img src="https://user-images.githubusercontent.com/106318111/176960604-7b0bfc9b-b401-4182-bec8-b68467870d41.png" width=160> <img src="https://user-images.githubusercontent.com/106318111/176960818-ca604bad-3ca2-432d-9c27-b3dcdef0ef79.png" width=160> <img src="https://user-images.githubusercontent.com/106318111/176960853-27f01ae9-0589-49b7-8e2d-ff49377e60cb.png" width=160> <img src="https://user-images.githubusercontent.com/106318111/176960862-ed4ca333-a14d-4d41-94d8-43ea2d081350.png" width=160> <img src="https://user-images.githubusercontent.com/106318111/176960880-6c581d8c-41c0-4574-865e-ed92df6d1802.png" width=160> <img src="https://user-images.githubusercontent.com/106318111/176960889-2105bb0a-5542-41c0-8708-93ff08ca8acf.png" width=160>


## Features
- Customizable ASMR profiles: 
  
  Create a profile with specific ASMR categories you like and application will play you sounds from this categories with added fade ins\outs in between. 
  
- Discover tab for YouTube ASMR videos
- Downloading new ASMR sounds as they are added
- User categories\ASMR sound:

  You can upload your own categories and ASMR sounds here:

  [Add new category](https://asmixer.ru/category/add)

  [Upload new sounds](https://asmixer.ru/sample/add)

  After the approval, you'll be able to download your newly added samples on the library screen.
  
 - Light\Dark theme
 
 ## Content

Currently sounds\categories library is very limited, more sounds might be added if people are interested in the app. You can also help by adding new sounds and categories [here](https://asmixer.ru/).
 
 ## Building
 
 In the root folder of the project create a file named Constants.dart with this string inside:
 
 ```
 const String youtubeApiKey = "YOUR_YOUTUBE_API_KEY";
 ```
 
[How to get a YouTube API key](https://developers.google.com/youtube/v3/getting-started)

Other than that there are no specific actions required to build the project.

### IOS

Application should build for IOS but it's untested.

## Server

Server's source code is available [here](https://github.com/devisnotavailable/ASMixeR-Server/).

## License

[![GNU GPLv3 Image](https://www.gnu.org/graphics/gplv3-127x51.png)](https://www.gnu.org/licenses/gpl-3.0.en.html)  

ASMixeR is Free Software: You can use, study, share, and improve it at will. Specifically you can redistribute and/or modify it under the terms of the [GNU General Public License](https://www.gnu.org/licenses/gpl.html) as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
