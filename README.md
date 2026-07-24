# Smile Sunshine Enterprise System

A C# WinForms academic prototype for managing products, customers, sales orders, users, roles, and permissions with a MySQL database.

## Project Overview

Smile Sunshine Enterprise System is a desktop application created as a three-person team course project. The repository contains the implemented prototype, not a production-ready enterprise system. Some menu entries in the interface are placeholders and are not presented as completed features here.

## Implemented Features

- Login and in-memory user session handling
- Role-based menu filtering and page access checks
- Product creation, viewing, editing, deletion, stock display, and local image management
- Customer creation, editing, deletion, refresh, and name search
- Sales order creation, listing, detail display, editing, and deletion
- Department management
- User management, role assignment, filtering, deletion, and password reset
- Role management and permission assignment
- Permission management

Dispatch, refund, repair, inventory control, and similar placeholder menu entries are not implemented modules.

## Technology Stack

- C# and .NET Framework 4.7.2
- Windows Forms
- MySQL
- `MySql.Data` 9.3.0 with ADO.NET-style commands and readers
- Visual Studio solution and classic `packages.config` dependency management

## Project Structure

```text
.
|-- SmileSunshine.sln
|-- DesktopApp/
|   |-- Control/          # Pages, forms, sidebar, and reusable controls
|   |-- Database/
|   |   |-- Func/         # MySQL data-access classes
|   |   `-- Table.cs      # Database model classes
|   |-- Forms/            # Supporting forms
|   |-- Image/            # Required UI and sample product images
|   |-- Properties/       # WinForms resources and project metadata
|   |-- Utils/            # Session and image helpers
|   |-- Program.cs        # Application entry point
|   |-- App.config
|   |-- DesktopApp.csproj
|   `-- packages.config
`-- database/
    |-- schema.sql
    `-- seed.example.sql
```

## Prerequisites

- Windows
- Visual Studio 2019 or later
- The **.NET desktop development** workload
- .NET Framework 4.7.2 Developer Pack
- MySQL Server compatible with the schema
- NuGet package restore enabled

## Database Setup

1. Create the database objects:

   ```text
   mysql -u <administrative-user> -p
   mysql> SOURCE database/schema.sql;
   ```

2. Optionally load the fictional demonstration data:

   ```text
   mysql -u <administrative-user> -p smile_sunshine
   mysql> SOURCE database/seed.example.sql;
   ```

3. Create a dedicated least-privilege MySQL account for the application. Do not use a personal account or commit its password.

4. Set the connection settings in the process environment before starting the application:

   ```powershell
   $env:SMILE_DB_SERVER = "localhost"
   $env:SMILE_DB_PORT = "3306"
   $env:SMILE_DB_NAME = "smile_sunshine"
   $env:SMILE_DB_USER = "<local-application-user>"
   $env:SMILE_DB_PASSWORD = "<local-application-password>"
   ```

`SMILE_DB_USER` and `SMILE_DB_PASSWORD` are required. No database password is stored in this repository.

## Build and Run

1. Open `SmileSunshine.sln` in Visual Studio.
2. Restore NuGet packages.
3. Select `Debug` or `Release` with `Any CPU`.
4. Build the solution.
5. Configure the database environment variables in the process that launches the application.
6. Run `DesktopApp`.

The command-line build requires the full Visual Studio/.NET Framework MSBuild toolchain. The cross-platform `dotnet msbuild` command alone may fail while processing WinForms resources.

## Role-Based Access Control

The prototype stores users, roles, permissions, user-role mappings, and role-permission mappings in MySQL. After login, the application loads the current user into a session, filters menu items by permission, and checks the requested page key before navigation.

This is application-level UI access control for an academic desktop prototype. It should not be treated as a complete security boundary; production software should also enforce authorization in its service or data-access layer.

## Known Limitations

- The authentication code currently compares application passwords directly and includes a predictable reset-password workflow. It is retained to avoid a large behavioral rewrite of the course prototype and is not suitable for production use.
- A future version should use a modern password-hashing function such as Argon2, bcrypt, or PBKDF2 with a unique salt, random expiring reset credentials, and a forced password change.
- Database operations are synchronous and tightly coupled to WinForms controls.
- Error handling and logging are inconsistent.
- Several menu entries are placeholders that open the dashboard.
- The repository has no automated test project.
- Product image storage is local-machine dependent.
- A clean build must be verified on a machine with Visual Studio and the .NET Framework 4.7.2 developer tools installed.

## Team Project Notice

This software was developed as a three-person academic team project. The public repository must not be interpreted as evidence that one person independently designed and implemented the entire system. Contributors should describe only the work they can personally substantiate.

## My Contributions

> Replace this section before publishing. List only your verified contributions, such as specific screens, data-access classes, database design work, UML diagrams, testing, or documentation. Do not claim the entire team project.

- TODO: Describe the modules you personally implemented.
- TODO: Describe your database or UML contributions.
- TODO: Link the relevant commits or pull requests after version control is established.
