# AQ-Redback

## Project Objectives
Aquaterra, an organization specializing in simplifying and cost-effective online farming solutions utilizing parameters such as soil moisture and temperature, currently operates a web platform developed on AWS cloud services and a PostgreSQL backend. The platform facilitates user access to crucial moisture data across different sections of their fields.

The current focus involves developing a mobile application to optimize customer data presentation. This strategic move aims to elevate customer satisfaction and extend the company's market reach. The organization's proficient IT team will provide guidance to the team, encouraging them to leverage their creativity and innovation in designing the application.  
Source: https://canvas.lms.unimelb.edu.au/courses/156871/pages/aquaterra-code-aq?module_item_id=4949498  

## Project Goals
* Mobile Application Development

Design and develop a user-friendly mobile application to empower farmers to effectively manage and monitor sensor data from their farm fields. The application will provide a convenient platform for accessing real-time and historical data related to soil moisture, moisture depth, soil temperature, evaporation, and precipitation variations captured by the sensors.

* Transition from Web to Mobile

Successfully migrate features from the existing Aquaterra web platform to the mobile application. This transition should maintain core feature consistency while optimizing the user experience for mobile devices.

* Comprehensive Data Monitoring

To enable farmers to have a comprehensive view of their farm's status by offering insights into critical parameters. Farmers should be able to track fluctuations in moisture levels and temperature, allowing for timely adjustments in irrigation and other farming practices.

* Enhanced Data Representation

To present sensor data in a visually appealing and understandable manner. The mobile application will utilize graphs, charts, and intuitive interfaces to convey complex data trends and patterns, enabling farmers to make informed decisions based on the information at hand.

* Real-time Notifications

To provide a mechanism for sending real-time notifications and alerts to farmers. Alerts can be triggered by specific conditions such as sudden changes in moisture levels, extreme temperatures, or other parameters that may impact crop health. This feature ensures that farmers can respond promptly to emerging challenges.

# Current phase
This semester, our team undertook this project with the following goals: 
### Design Phase:
* Engaged in the active design phase of our iOS app.
* Maintaining continuous communication with the client to craft a refined prototype.
* Prioritizing a seamless integration of the client's vision into the design process.

### Collaboration:
* Emphasizing collaboration with the client to fuse their ideas with innovative design elements.
* Ensuring the prototype design aligns precisely with client expectations.

### Feature Analysis and Prioritization:
* Identifying core app features that define functionality and user experience.
* Scrutinizing each feature to assess impact and significance.
* Applying a comprehensive evaluation framework to assign priority levels.
* Prioritization criteria include user value, technical feasibility, and alignment with app goals.

### Outcome:
* Striving for a balanced synthesis of visionary design and meticulous execution.
* Enabling methodical implementation for enhanced user engagement and performance.
* Delivering an iOS app that surpasses expectations through professionalism and proficiency.

## Our Team
| Name  | Role | Responsibilities and Regular Activities |
| ------------- | ------------- | ------------- |
| Yunqing Yu  | Product Owner | <li>Reassess the product backlog of development tasks and adjust priorities as needed.<li>Maintain constant accessibility during development to address team members' inquiries and prevent misunderstandings.<li>Establish clear sprint objectives and goals.<li>Monitor updates, feedback, and inquiries from clients.|
| Yilin Liu  | Scrum Master | <li>Ensure timely delivery of planned features within each sprint.<li>Conduct and coordinate standup meetings and other Scrum ceremonies.<li>Regularly oversee the Kanban board and allocate tasks to team members.<li>Maintain vigilance over project updates and progress, offering proactive feedback. |
| Bowei Huang  | Dev Lead | <li>Engage in routine standup meetings, providing updates on ongoing development progress and sharing feedback.<li>Collaboratively address bugs and defects in the code, working together to find effective solutions.<li>Regularly monitor the Kanban board to stay informed about new changes and updates. |
| You Zhou  | Dev Member | <li>Engage in routine standup meetings, providing updates on ongoing development progress and sharing feedback.<li>Collaboratively address bugs and defects in the code, working together to find effective solutions.<li>Regularly monitor the Kanban board to stay informed about new changes and updates. |
| Jiakang Li  | Quality Manager | <li>Monitoring and inspecting our mobile application to identify deviations from quality standards and taking corrective actions when necessary.<li>Identifying potential quality risks and implementing measures to mitigate them. |

## Our Stakeholders  
| Role  | Name | Contacts |  
| ------------- | ------------- | ------------- |
| Client (AquaTerra Group)  | Lokesh Chandra | lokesh.spark.1651@gmail.com |  
| IT Support (AquaTerra Group)  | Sean Wei | sean.wei@unimelb.edu.au |  
| Supervisor  | Wei Wang | wang.w11@unimelb.edu.au |  


## Road Map
| Event  | Date |
| ------------- | ------------- |
| Sprint 1  | 03/18/2023 - 17/08/2023 | 
| Sprint 2  | 18/08/2023 - 22/09/2023 | 
| Sprint 3  | 22/09/2023 - 20/10/2023 | 

## Preparation for Development Tools and Technologies  
| Technology/Concept           | Description                                                                                                                                                                                           |
|-----------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Xcode                       | Xcode serves as the development environment for iOS app creation.                                                                                                                                      |
| Swift Programming Language  | Xcode features built-in support for the Swift programming language, ensuring a seamless experience for coding in Swift.                                                                                 |
| APIs and Libraries          | Additional resources can be found in the Swift documentation at [https://www.swift.org/documentation/#](https://www.swift.org/documentation/#).                                                   |
| UIKit or SwiftUI           | Apple offers two UI frameworks for interface development: UIKit, a long-standing framework known for its flexibility and control, and SwiftUI, a newer declarative framework that simplifies UI development with less code. |
| Interface Builder          | Within Xcode, developers can access Interface Builder, a visual tool for designing user interfaces. This tool facilitates the creation and arrangement of UI elements through visual means, which can then be linked to Swift code. |
| Version Control System     | The utilization of a version control system, such as Git, plays a crucial role in code tracking, collaboration, and the management of multiple app versions.                                              |
| iOS SDK                     | The iOS Software Development Kit encompasses an array of APIs, frameworks, and tools essential for app development. This kit provides access to device functionalities like the camera, location services, sensors, and more.       |
| Apple Developer Account    | For testing and app distribution via real devices or the App Store, developers are required to possess an Apple Developer account. This entails enrollment in a program and the acquisition of certificates and provisioning profiles. |

### Sprint 2 Release  
In Sprint 2, we focused on key functionalities, and we have completed the following:

1. Farm and Field Management: We have implemented robust features for farm and field management to streamline operations.

2. Sensor Registration: Our team has developed a seamless sensor registration process, ensuring that data collection is both efficient and accurate.

3. Gateway Registration: The gateway registration system is in place, enhancing the connectivity and data flow within the system.

4. Login and Logout Functionality: Secure login and logout features have been integrated, ensuring data confidentiality and user control.

Additionally, we have laid the foundation for the dashboard page by creating a template. While the template showcases our design and layout, please note that the complete dashboard functionality will be implemented in the next sprint.

### Sprint 3 Release  
In Sprint 3, we focused on the implementation of the dashboard, user profile page, irrigation zone management page and the registration, and deletion of version 2 sensors, and we have completed the following:

1. Irrigation Zone Management: This feature has enabled users to register new irrigation zones on their desired field by entering the zone name, crop types, crop wilting point, saturation point, capacity etc and the zone location. It also allows user to edit their zone information and delete the zone if it is no longer in use.

2. Version 1 Sensor Registration: This feature enabled the registration of version one sensors by finding the related gateways to this sensor, pairing one of the gateways to the physical sensor and choosing the location on the map where the sensor should be installed.

3. User Profile: This page enabled users to see their relevant details such as name, email address, phone number, subscription type, and expiry date. However, this information can not be edited on the app and the users would be notified to edit their information on the web application.

4. Dashboard Page: This page enabled users to get a quick overview of the sensors, their current status and their statuses over time. Users can view the moisture level, battery level, and temperature level of each sensor within the field.  They can see details of each sensor, their evaporation over time, average soil moisture as well as the weather prediction of the field.

### Product Demonstration  
Our final product demonstration video can be found on youtube: https://youtu.be/CvloBxfRaH0. Please visit this link to have a better view of the video.

### Product Depolyment
Our ios mobile app product has been deployed and uploaded to testflight for testing. Please visit this link: https://testflight.apple.com/join/g5narCPW and follow in instructions to use the app on iphone devices.


### Test Plans  
https://confluence.cis.unimelb.edu.au:8443/pages/viewpage.action?pageId=146647404  
https://confluence.cis.unimelb.edu.au:8443/pages/viewpage.action?pageId=146667337  

## Structure of folders  
├── docs/ # This folder contains documentation and project artifacts  
├── src/  # This folder contains src code  
├── tests/ # User/system tests  
├── data samples/ # The API doc provided by client  
└── README.md  


## Development Processes & Specifications
To standardize development and enhance teamwork, please follow these guidelines:

- **Branching Strategy** - Create a **main branch (e.g., main or master)** for stable versions and **development branches** for specific features. Avoid changes to the main branch.

- **Feature Branches** - Team members should use feature branches off the development branch for working on specific tasks. Merge them back for integration.

- **Pull Requests and Review** - Create Pull Requests for merging. One team member should review for quality and consistency.


- **Regular Merging and Releases** - Periodically merge development into the main branch for stability. Plan releases for new features.

For more details, watch these two tutorial videos - [Tutorial Video1](https://www.youtube.com/watch?v=jhtbhSpV5YA&ab_channel=AkoDev) - [Tutorial Video2](https://www.youtube.com/watch?v=RYDCwj37ous&ab_channel=SoftwareSageLLC).  

## Prerequisites

### General Prerequisites
1. Xcode
   - Install from the App Store
2. AWS Amplify CLI
   - Install by using this command in Terminal:
   ```bash
   curl -sL https://aws-amplify.github.io/amplify-cli/install | bash && $SHELL
   ```
3. Clone the AquaTerra Project

### Pod Install
```bash
sudo gem install cocoapods
```
```bash
pod install --repo-update
```
### AWS Amplify  
After cloning the repo, please make sure that the local Amplify cli has connected to the correct backend by running the following steps:
```bash
amplify init
```
# The setup 
* Select in Default  
* Editor choose Xcode  

```bash
amplify push
```
### Run the project
After set up the environment, you can use Xcode to run the project by open the __"AquaTerra.xcworkspace"__.
 
