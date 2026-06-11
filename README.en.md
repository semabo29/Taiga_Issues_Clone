<div align="center">
  <h1>ASW Taiga Issue Tracker</h1>
  <p><em>Web application for issue management and tracking inspired by Taiga.</em></p>

  <p>
    <a href="README.md">💬 Català</a> | <b>🌍 English</b>
  </p>

  <img src="https://img.shields.io/badge/Ruby-CC342D?style=flat-square&logo=ruby&logoColor=white" alt="Ruby" />
  <img src="https://img.shields.io/badge/Rails-CC0000?style=flat-square&logo=ruby-on-rails&logoColor=white" alt="Rails" />
  <img src="https://img.shields.io/badge/PostgreSQL-316192?style=flat-square&logo=postgresql&logoColor=white" alt="Postgres" />
  <img src="https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white" alt="Docker" />
  <img src="https://img.shields.io/badge/Render-46E3B7?style=flat-square&logo=render&logoColor=white" alt="Render" />
</div>

<br />

Project developed for the Web Applications and Services (ASW) subject at the Universitat Politècnica de Catalunya (UPC). This project replicates the core functionalities of a professional Issue Tracker, implementing a robust RESTful API and a scalable architecture.

🌍 **Production Environment:** [Taiga App (Render)](https://taiga-app.onrender.com) *(Note: The server may take a few seconds to start due to free tier policies).* 

🌲 **Organization:** [Project organization on Taiga](https://tree.taiga.io/project/victorsalinasmontanuy-asw2526q2-it212)

---

## ✨ Project Demonstration

The following video (1:30 min) shows the complete main flow of the application:

https://github.com/user-attachments/assets/1831e4b5-19a0-4d83-a993-08b70420b00b

*(Note: Features such as View Profile or Bulk Insert, among others, are outside the project's Main Flow but are fully implemented).*

The following image shows the view of a Profile that does not belong to the current user:

<img src="https://github.com/user-attachments/assets/3bad8143-0b86-4692-b960-77dc38f6c3ec" alt="Profile" width="800" />

---

## 🚀 Key Features

The application replicates the core of a Taiga-style Issue Tracker, adapted with specific business rules for the subject. The features are divided into three main blocks:

### 1. Issue Management
*   **Complete Lifecycle:** Creation, viewing, editing, and deletion of issues. For security reasons, **only the creator** of the issue has permissions to edit or delete it.
*   **Direct Assignment:** Direct selector integrated into the view to immediately assign an issue to any team member.
*   **File Attachments:** File uploads via a direct action button and a simple list associated with the issue. Only the creator of the attachment can delete it (persistently stored in an **AWS S3 Bucket** via Active Storage).
*   **Comments and Activity:** Integrated discussion system (add, list, edit, and delete comments, restricted to their author). Includes a chronological **Activity history** for each issue.
*   **Advanced Search and Filtering:**
    *   "Include" type filters to narrow down lists.
    *   Textual search on the *Subject* and *Description* fields executed on demand when pressing the search button.
*   **Bulk Insert:** Functionality for the mass creation of issues at once to speed up workflow.
*   **Deadlines and Watchers:** Deadline control (add, view, and delete deadlines) and subscription system (Watch/Unwatch) to follow issues.

### 2. User Control and Profiles
*   **External Authentication (Social Login):** Unified registration and login system via **Google OAuth2**. The user account is automatically created in the database upon the first "Sign In".
*   **Public Profile Pages:** Any user can visit another member's profile, rendering three dynamic tabs:
    *   **Open Assigned Issues:** Open issues assigned to the user (sortable by *type*, *severity*, *issue #*, *status*, and *modified*).
    *   **Watched Issues:** List of issues the user is following (visible **only** if the profile corresponds to the currently logged-in user).
    *   **Comments:** History of comments made, ordered from newest to oldest. Includes direct anchor links that take you exactly to the comment's position within the issue, as well as quick edit buttons.
*   **Profile Editing:** The user can customize their bio and profile picture (Avatar), which is also managed directly in cloud storage.

### 3. Project Configuration (Settings)
*   Centralized administration panel for the workspace where you can list, create, modify, and delete the master fields and global attributes of the project:
    *   *Statuses*
    *   *Priorities*
    *   *Types*
    *   *Severities*
    *   *Tags*
    *   *Due dates*

---

## 🔌 REST API (Second Assignment)

The project includes a Level 2 REST API (Richardson Maturity Model) to manage issues, users, comments, and attachments.

* **Documentation (OpenAPI):** You can find the complete specification in the `/api/api.yml` file.
* **How to test it:**
    1. Go to [Swagger Editor](https://editor.swagger.io/) and load our `api.yml` file.
    2. Sign up or log in to our [Render App](https://taiga-app.onrender.com).
    3. Go to your Profile to copy your **API Key**.
    4. In Swagger, click "Authorize" and paste the key into the header to start making requests.

---

## Prerequisites

| Tool | Minimum Version |
|------|---------------|
| [Ruby](https://www.ruby-lang.org/en/downloads/) | 3.3.6 |
| [Rails](https://rubyonrails.org/) | 7.1.3 |
| SQLite3 | - |
| [Docker](https://www.docker.com/) *(optional, for deployment)* | 24+ |


---

## Local Setup

```bash
# 1. Clone the repository
git clone https://github.com/semabo29/Taiga_Clone_Project.git 
cd Taiga_Clone_Project

# 2. Install dependencies
bundle install

# 3. Configure environment variables
# Create a .env file in the project root and add your authentication (Google)
# and cloud storage (AWS S3) credentials:

#   GOOGLE_CLIENT_ID=your_client_id
#   GOOGLE_CLIENT_SECRET=your_client_secret
#
#   AWS_ACCESS_KEY_ID=your_access_key
#   AWS_SECRET_ACCESS_KEY=your_secret_key
#   AWS_SESSION_TOKEN=your_temporary_session_token
#   AWS_REGION=us-east-1
#   AWS_BUCKET=aswtaiga-bucket

# 4. Prepare the database (creation and migrations)
rails db:prepare

# 5. Run the application
bin/rails server -b 0.0.0.0
```

---

## Project Structure

```text
ASW_Taiga_Project/
├── app/
│   ├── controllers/      # Business logic and route protection (e.g., authenticate_user!)
│   ├── models/           # Data models (Issue, User, Status, Priority, Tags, Comments...)
│   ├── views/            # Dynamic views (ERB) with filtering and lists
│   └── assets/           # Stylesheets and manifest configuration
├── config/
│   ├── routes.rb         # HTTP endpoints definition
│   ├── database.yml      # Configuration for SQLite (Local) and PostgreSQL (Production)
│   └── initializers/     # Startup configurations (e.g., omniauth.rb for Google)
├── db/                   # Migrations and schema.rb file
├── Dockerfile            # Build recipe for the production environment
└── bin/docker-entrypoint # Automatic startup and migrations script on the server
```

---

## CD

* **CD** (`.github/workflows/cd.yml`): Runs when merging to `main`. Deployment to production is fully automated. The repository's Dockerfile is used to build an optimized image that runs on Render, connected to a PostgreSQL database.

---

## Key Technologies

| Layer                  | Technology                    |
| ---------------------- | ----------------------------- |
| Web Framework          | Ruby on Rails 7.1.3           |
| Language               | Ruby 3.3.6                    |
| DB (Local)             | SQLite3                       |
| DB (Production)        | PostgreSQL                    |
| Authentication         | Google OAuth2 (OmniAuth)      |
| File Management        | Active Storage (AWS S3 ready) |
| Environment/Containers | Docker                        |
| Hosting                | Render                        |

---

## Team

| Name                    |
| ----------------------- |
| Clàudia Galán Rodoreda  |
| Sergi Malaguilla Bombín |
| Adrià Aguilar Garcia    |
| Victor Salinas Montanuy |

**Professor:** Quim Motger De La Encarnacion

**Subject:** Web Applications and Services (ASW) — Bachelor's Degree in Computer Engineering (UPC)

**Term:** Spring Semester, Academic Year 2025/26
