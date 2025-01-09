# Tourist-Utility-App-Swift

Tourist Utility App: Real-Time Weather, Air Quality, and Tourist Attractions
This SwiftUI-based Tourist Utility App provides real-time weather and air quality information for any location, along with a map highlighting the top 5 tourist attractions in the area. The app is designed to enhance user experience with seamless data updates, intuitive navigation, and visually appealing UI components.

# Images

<img width="262" alt="Screenshot 2025-01-09 at 15 37 09" src="https://github.com/user-attachments/assets/24692770-2331-4869-bb0c-7576ecf33cd8" />
<img width="262" alt="Screenshot 2025-01-09 at 15 37 19" src="https://github.com/user-attachments/assets/b0094c27-1783-4965-b803-1bdbc5361519" />
<img width="262" alt="Screenshot 2025-01-09 at 15 37 26" src="https://github.com/user-attachments/assets/c2f5b20f-b63a-4b98-a7e4-ffbc93e0f7ab" />



Features
Real-Time Weather and Air Quality Data
Fetch accurate, up-to-date weather and air quality data using the OpenWeatherMap API. Display comprehensive details such as temperature, humidity, wind speed, and air quality indices.

Top Tourist Attractions
Use Apple’s MapKit to identify and display the top 5 tourist attractions for the selected location. A map view with pins and a scrollable list provide a detailed overview.

Dynamic Location Management

Update weather, air quality, and attractions dynamically when a new location is entered.
Save visited locations with their geo-coordinates in a local database.
Detect previously visited locations and fetch data without repeated API calls.
Handle invalid location entries gracefully with user-friendly alerts.
Stored Places Management
View a list of saved locations along with their coordinates. Use swipe actions to delete locations from the database permanently.

User-Friendly UI
Designed with SwiftUI to deliver a seamless and visually consistent user experience. Features include scrollable weather views, pinned maps, and clean data formatting, following Apple’s UI/UX guidelines.

Technology Stack

SwiftUI: For building the app's user interface.
CoreLocation: To manage and retrieve user location details.
MapKit: For map rendering and displaying tourist attractions.
OpenWeatherMap API: To fetch real-time weather and air quality data.

Functional Requirements
Display real-time weather and air quality data for a default location (London) on app launch.
Seamless updates across all views when a new location is entered.
Alerts for previously visited locations, invalid entries, and database updates.
Fully responsive design with scrollable views for weather forecasts and attraction details.

Non-Functional Requirements
Adheres to Apple’s interface design guidelines.
Ensures consistency in app interactions.
Provides correctly formatted data and a visually polished UI.

How to Run
Clone this repository to your local machine.
Open the project in Xcode (ensure you’re using the latest version compatible with SwiftUI).
Obtain a free API key from OpenWeatherMap and replace the placeholder in the code with your key.
Build and run the app on a macOS device or simulator.
