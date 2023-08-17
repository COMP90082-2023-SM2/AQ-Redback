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
| Lokesh Chandra  | Client |  |  

## Road Map
| Event  | Date |
| ------------- | ------------- |
| Sprint 1  | 17/08/2023 | 
| Sprint 2  | 18/08/2023 - 22/09/2023 | 
| Sprint 3  | 22/09/2023 - 20/10/2023 | 

## Preparation for Development Tools and Technologies  
* Xcode: Development Environment  
* Swift Programming Laguange: Xcode comes equipped with integrated support for the Swift programming language, making it a seamless platform for coding in Swift.
* Apis and Libraries: https://www.swift.org/documentation/#
* UIKit or SwiftUI: These are UI frameworks provided by Apple for building user interfaces. UIKit has been used for many years and offers a lot of flexibility and control. SwiftUI is a newer declarative framework that simplifies UI development with less code.
* Interface Builder: Xcode includes Interface Builder, a visual tool for designing user interfaces. You can use it to create and arrange UI elements visually, and then connect them to your Swift code.
* Version Control System: Using a version control system like Git is crucial for tracking changes to your code, collaborating with other developers, and managing different versions of your app.
* iOS SDK: The iOS Software Development Kit includes APIs, frameworks, and tools for building apps. It provides access to device features like camera, location, sensors, and more.
* Apple Developer Account: To test and distribute your app on real devices or through the App Store, you'll need an Apple Developer account. This involves enrolling in a program and obtaining certificates and provisioning profiles.



## Structure of folders  
├── docs/ # This folder contains documentation and project artifacts  
├── src/  # This folder contains src code  
└── README.md  


## Development Processes & Specifications
To ensure standardization of development and improve teamwork. Please observe the following:
* **Set Up Branching Strategy**: Generally, you can consider creating a **main branch (typically named main or master)** and **development branches**. The **main branch** can hold **stable versions**, while **development branches** are used for team members to work on specific features. This helps avoid making direct changes to the main branch and reduces potential conflicts.
* **Create Feature Branches**: For effective collaboration, it's recommended that team members create feature branches off the development branch for developing specific features or fixes. Once the feature development is complete, the branch can be merged back into the development branch to ensure code integration and stability.
* **Pull Requests (PRs) and Code Review**: After completing work on a feature branch, team members can create a Pull Request to merge it back into the development branch. This allows for code review, where team members can provide feedback and suggestions for improvement. At least one team member should review the code to ensure quality and consistency.
* **Regular Merging and Releases**: Periodically merge the development branch back into the main branch to keep the main branch up to-date and stable. 

If you are not familiar with this, please watch this tutorial video! https://www.youtube.com/watch?v=jhtbhSpV5YA&ab_channel=AkoDev  
