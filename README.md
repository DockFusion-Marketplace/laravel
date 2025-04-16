# Laravel in Docker
This is a pre-configured Laravel environment designed to run seamlessly with DockFusion - your Docker app manager. This template provides an out-of-the-box Laravel development setup with Docker, including PHP, and Apache, so you can focus on building your app, not on configuring your stack.

## 🚀 What's Included
The quickest way to get started with the Deck Laravel Development Container is using docker-compose.

- Laravel (9+) — PHP web framework
- PHP (8.0+) — Handles PHP processing
- NVM (0.40.2) — Manages multiple Node.js versions with ease
- NODE (20+) — JavaScript runtime for backend tools, asset building, and full-stack functionality
- npm/yarn — Package managers for installing Node-based tooling like Vite and Laravel Mix
- Apache — Serves your Laravel app
- Composer — Dependency management
- Docker Compose — Multi-container orchestration

## 📦 Requirements
- [Docker](https://www.docker.com)
- [Dock Fusion](https://github.com/DockFusion/dock-fusion-app/releases)

## 💡 Tips
- ### **xdebug in Vs Code**

    Create the file `.vscode/launch.json` and paste the following content
    ```json
    {
        "configurations": [
            {
                "name": "Listen for Xdebug",
                "type": "php",
                "request": "launch",
                "port": 9003,
                "hostname": "0.0.0.0",
                "pathMappings": {
                  "/var/www/html": "${workspaceFolder}"
                }
            }
        ]
    }
    ```