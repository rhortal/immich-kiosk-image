# Immich Kiosk Monitor

This repository monitors the main branch of [damongolding/immich-kiosk](https://github.com/damongolding/immich-kiosk) and automatically builds Docker images for Linux/x86_64 architecture when changes are detected.

## Features

- **Automated Monitoring**: Checks the upstream repository daily at midnight UTC for changes
- **Docker Image Building**: Automatically builds and pushes Docker images to GitHub Container Registry
- **Multi-architecture Support**: Currently focused on Linux/x86_64 (can be extended)
- **Version Tagging**: Uses commit SHA and timestamps for image tagging
- **GitHub Actions Integration**: Fully automated CI/CD pipeline

## How It Works

1. **Scheduled Check**: A GitHub Action runs daily at midnight UTC to check for new commits in the upstream repository
2. **Change Detection**: Compares the latest commit SHA with the previously stored one
3. **Trigger Build**: If changes are detected, triggers the Docker build workflow
4. **Build & Push**: Builds the Docker image for Linux/x86_64 and pushes to GitHub Container Registry
5. **Update State**: Stores the new commit SHA for future comparisons

## Image Tags

Images are tagged with:
- `latest`: Always points to the most recent successful build
- `{commit-sha}`: The specific commit SHA from the upstream repository
- `{timestamp}`: ISO 8601 timestamp of when the build was triggered

## Usage

Pull the latest image:
```bash
docker pull ghcr.io/YOUR_USERNAME/immich-kiosk-image:latest
```

Pull a specific version:
```bash
docker pull ghcr.io/YOUR_USERNAME/immich-kiosk-image:{commit-sha}
```

## Repository Structure

```
.
├── .github/
│   └── workflows/
│       ├── monitor.yml          # Monitors upstream repository
│       ├── build-docker.yml     # Builds Docker images
│       └── test.yml             # Test workflows
├── scripts/
│   └── check-upstream.sh        # Script to check for changes
├── README.md                    # This file
├── DEVELOPMENT.md               # Development guide
└── .gitignore                   # Git ignore rules
```

## Setup

1. Fork this repository
2. Enable GitHub Actions in your repository
3. The workflows will start automatically

## Requirements

- GitHub repository with Actions enabled
- GitHub Container Registry access (automatically available for public repositories)

## License

This monitoring setup is provided as-is for educational and personal use. The original immich-kiosk project is licensed under AGPL-3.0.