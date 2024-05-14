
# Appcent News App 

Appcent iOS case study app.

## Table of Contents
* [Screenshots](#screenshots)
* [Requirements](#requirements)
* [Design Pattern](#design-pattern)
* [Dependencies](#dependencies)
* [Setup](#setup)

## Screenshots

### Dark
<div align="left">
    <img src="/AppCentChallange-2024/AppCentChallange-2024/Screenshots/1.png" width="200px"</img>
    <img src="/AppCentChallange-2024/AppCentChallange-2024/Screenshots/2.png" width="200px"</img>
    <img src="/AppCentChallange-2024/AppCentChallange-2024/Screenshots/3.png" width="200px"</img>
    <img src="/AppCentChallange-2024/AppCentChallange-2024/Screenshots/4.png" width="200px"</img>
    <img src="/AppCentChallange-2024/AppCentChallange-2024/Screenshots/5.png" width="200px"</img>
    <img src="/AppCentChallange-2024/AppCentChallange-2024/Screenshots/6.png" width="200px"</img>
    <img src="/AppCentChallange-2024/AppCentChallange-2024/Screenshots/7.png" width="200px"</img>
    <img src="/AppCentChallange-2024/AppCentChallange-2024/Screenshots/8.png" width="200px"</img>
</div>

### Light
<div align="left">
    <img src="/AppCentChallange-2024/AppCentChallange-2024/Screenshots/1-light.png" width="200px"</img>
    <img src="/AppCentChallange-2024/AppCentChallange-2024/Screenshots/2-light.png" width="200px"</img>
    <img src="/AppCentChallange-2024/AppCentChallange-2024/Screenshots/3-light.png" width="200px"</img>
    <img src="/AppCentChallange-2024/AppCentChallange-2024/Screenshots/4-light.png" width="200px"</img>
    <img src="/AppCentChallange-2024/AppCentChallange-2024/Screenshots/5-light.png" width="200px"</img>
    <img src="/AppCentChallange-2024/AppCentChallange-2024/Screenshots/6-light.png" width="200px"</img>
    <img src="/AppCentChallange-2024/AppCentChallange-2024/Screenshots/7-light.png" width="200px"</img>
    <img src="/AppCentChallange-2024/AppCentChallange-2024/Screenshots/8-light.png" width="200px"</img>
</div>

## General Info
The Appcent News App is an iOS application developed for the Appcent case study using the `UIKit` framework. It consists of a total of 4 pages. These 4 pages are designed as follows: a Home page and a Saved News page created using `UICollectionView`, a News Detail page containing the detailed information of a news article, and a Safari page where you can view the source of the news in Safari.

On the Home page, you can use a `UISearchController` to list news articles related to the keyword you search for, sort them according to your preferred criteria, and browse through the news articles using pagination from the API. When you click on a news article on the Home page, you are directed to the Detail page. On the Detail page, you can find a detailed description of the news article, save the article, view the source of the article in Safari, or share the title, content, image, and source URL of the article.

On the Saved News page, you can view the news articles you have saved, navigate to the detail page, and remove articles from your saved list.

## Requirements
iOS 15+

## Design Pattern
In the iOS project developed using the `UIKit` framework, the `MVC (Model-View-Controller)` design pattern was utilized to enhance organization and separation of concerns. `MVC` is a foundational pattern in iOS development, providing clear divisions between data management, user interface, and application logic.

In this project, `MVC` was chosen to ensure a clear separation of concerns and maintainability of the codebase. Each component plays a specific role, leading to a well-structured and easily maintainable codebase. Additionally, adherence to MVC promotes code reusability and facilitates testing of individual components.

## Dependencies 





