# i-Aswaq
# Group Name : Glory
## Members
**ADAM BIN MUHAMMAD ZAHARI**  
Matric No. : 2314361  
Tasks Assigned:
1. purpose, target users and preferred platform

**AHMAD SHOLIHIN BIN KAMARUDDIN**  
Matric No. : 2210097  
Tasks Assigned:
1. features and functionalities

**MUHAMMAD HILMI BIN MOHD NAZI**  
Matric No. : 2218517  
Tasks Assigned:
1. title and background of the problem

**NIK MOHAMAD SYAMIN BIN MAT RAPI**  
Matric No. : 2219501  
Tasks Assigned:
1. features and functionalities

---
# Project Ideation & Initiation
## a. Title - Hilmi 2218517
i-Aswaq (Arabic for “the markets”) is a mobile marketplace application designed exclusively for IIUM students.
It allows them to buy and sell new or used items conveniently within the campus community.

## b. Background of the Problem - Hilmi 2218517
As the residents of Mahallahs on campus, we often rely on informal Mahallahs WhatsApp groups to buy and sell items within the university.It is unorganized, lacks of searchability and poses trust issues. This makes it difficult for buyers to find what they need and for sellers to reach the right audience.

The reason we proposed i-Aswaq, a centralized IIUM student-only marketplace is because it helps stream line transactions, build trust and promote sustainable reusability of items (e.g., used books, clothes, electronics, etc.) within the IIUM community.

## c. Purpose or Objective - Adam Zahari 2314361
The main objective of i-Aswaq is to provide a secure and easy-to-use digital marketplace for IIUM students to buy and sell items conveniently on campus.

## d. Target Users - Adam Zahari 2314361
The target users are IIUM Gombak Campus students who want a convenient way to buy and sell items within the university environment.

## e. Preferred Platform - Adam Zahari 2314361
The preferred platform for development is Android.

## f. Features and Functionalities - Syamin 2219501 & Sholihin 2210097

### 1. Search and Filters
Users can search for items by name, category, or price range.

Filters help narrow down results (e.g., by condition: new/used, or item type: books, electronics, clothing).

### 2. Real-Time Chat Between Buyer & Seller
Built-in chat function allows instant communication using Firebase Realtime Database or Cloud Firestore.

Users can discuss prices, arrange meetups, or ask about item details securely within the app.

### 3. CRUD for Listings (with Image Upload via Firebase Storage)
Sellers can Create, Read, Update, and Delete their listings.

Item images are uploaded and stored securely using Firebase Storage.

Each listing contains title, description, category, price, and seller contact.

### 4. Firebase Authentication
Ensures that only verified IIUM students can register and log in (e.g., using IIUM email).

Protects user accounts and provides secure access control.

### 5. Setup user profile
Users can manage profile details such as name, contact, and profile picture

---
# Requirement Analysis & Planning
## 1. Evaluate technical feasibility - Adam 2314361
## 2. Provide Sequence Diagram and Screen Navigation Flow - 2 members
//Sequence Diagram

//Screen Navigation Flow
### i-Aswaq — Screen Navigation Flow

#### 1. Splash Screen
↓  
#### 2. Login / Register Screen
- Login  
- Register  
↓ (after successful login)

---

#### Main App Navigation (Bottom Navigation Bar)
**Home | Categories | Sell | Chat | Profile**

---

##### A. Home Screen
- Featured items  
- Search bar → *Search Results Screen*  
- Quick filters  

#### Home → Item Details Screen
- Images, price, description, seller info  
- Buttons: Chat Seller, Report, Save  

#### Item Details → Chat Screen

---

#### B. Categories Screen
- List of item categories  

#### Category → Category Item List Screen  
#### Category Item List → Item Details Screen  
(Then same flow as Home → Item Details)

---

#### C. Sell Screen (Create Listing)
- Upload images  
- Enter item details  
- Select category & condition  

#### Sell → Listing Confirmation Screen

---

#### D. Chat Screen
- List of conversations  

#### Chat → Conversation Screen
- Real-time messaging  
- Option to view linked item  

#### Conversation → Item Details Screen

---

#### E. Profile Screen
- Personal details  
- My Listings  
- Edit profile  
- Logout  

#### Profile → My Listings Screen
- Edit listing  
- Delete listing  

#### My Listings → Edit Listing Screen  
#### Edit Listing → Save Changes / Delete Listing

---

#### Additional Flows

#### Search Flow
Home → Search Bar → Search Results Screen → Item Details → Chat

#### Filter Flow
Home / Category List → Filter → Apply Filters → Filtered Results → Item Details


## 3. Create Gantt Chart - 1 member

---
# Project Design
## UI and UX - 2 members
//Utilize the mobile design principles to accommodate small screen navigation with Flutter UI widgets and gestures.
//Accommodate navigation with human intuition or user experience principles and avoid confusion in navigating various screens.
//Come up with simple design using Figma(for better visualization) 
## Consistency - 1 member 
//Color, logo, screen, form, design pattern are consistent throughout multiple screens.
## Design Integration & Review - 1 member
//Assist other members in verifying usability and flow.
//Check for alignment between UI, UX, and consistency standards.
//Ensure all design components follow the same design system.

---
# Project Development
## Implement Core functionalities
//Implement the item listing feature (Create, Read, Update, Delete).
//Implement the item details screen (display description, images, seller info).
//Implement the search function (search by item name, category).
//Implement filters (price range, condition, category).
//Implement the real-time chat screen UI components.
//Handle navigation structure between Home → Categories → Item Details → Chat.
//Connect UI buttons and form inputs to their respective controllers/functions.
//Ensure screens load correctly with dummy data before backend integration.

---
# References


