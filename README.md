# Code challenge The Movie DB

## Instructions to build and run the app

- Run pod install command on the terminal.
- Open CodeChallengeMoviewDB.xcworkspace file.

## Architecture

MovieDB layer is the communication interface between the Presentation layer and API layer.

The use of protocols enables decoupling between the presentation layer and the layer responsible for loading data. For example, the API layer can be easily replaced by another implementation that comforms to the MovieDB protocols.

![architecture-diagram2](https://user-images.githubusercontent.com/10325730/147966724-d8011e6d-a2cf-4b34-a940-69aa2d8ba09d.png)

In this project URLSession has been used to load data from movies API, but it is possible to change it for another implementation. It is possible to use a different library (Alamofire for example) or create another loading data aproache, like recovering data from cache,  without side effects to the presentation layer due to low coupling.

MVVM architecture was used in presentation layer with closures for communication between ViewModel and View. 

## Third-party libraries
- Kingfisher: Swift library for downloading and caching images from the web. It is used to help the loading of images into UIImageView.
