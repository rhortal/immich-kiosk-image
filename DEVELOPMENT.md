# Development Guide

## Local Development

To test the monitoring setup locally:

1. **Prerequisites**:
   - `curl` for API calls
   - `jq` for JSON parsing

2. **Test the upstream check script**:
   ```bash
   ./scripts/check-upstream.sh
   ```

3. **Manual testing**:
   - Delete the `.last-commit` file to simulate first run
   - Run the script again to see change detection

## GitHub Actions Testing

1. **Test the monitor workflow**:
   - Go to Actions tab in GitHub
   - Select "Monitor Upstream Repository" workflow
   - Click "Run workflow" to trigger manually

2. **Test the Docker build**:
   - Go to Actions tab
   - Select "Build Docker Image" workflow  
   - Click "Run workflow" with desired inputs

3. **Test the complete setup**:
   - Run the "Test Monitor Setup" workflow to verify everything works

## Configuration

### Monitoring Frequency

To change how often the repository is checked, edit the cron schedule in `.github/workflows/monitor.yml`:

```yaml
schedule:
  - cron: '*/5 * * * *'  # Every 5 minutes
```

Examples:
- `*/10 * * * *` - Every 10 minutes
- `0 * * * *` - Every hour
- `0 */6 * * *` - Every 6 hours

### Docker Image Tags

The build workflow creates three tags:
- `latest` - Most recent build
- `{short-sha}` - First 8 characters of commit SHA
- `{timestamp}` - Build timestamp (YYYYMMDDHHMMSS format)

### Architecture Support

Currently configured for `linux/amd64`. To add more architectures, modify the `platforms` parameter in `build-docker.yml`:

```yaml
platforms: linux/amd64,linux/arm64
```

## Troubleshooting

### Common Issues

1. **API Rate Limits**: GitHub API has rate limits. The monitoring uses unauthenticated requests with a lower limit.
   
2. **Build Failures**: Check the Docker build logs for specific errors. Common issues:
   - Upstream repository build failures
   - Network connectivity issues
   - Resource constraints

3. **Workflow Permissions**: Ensure the repository has Actions enabled and proper permissions for GitHub Container Registry.

### Debugging

1. **Check workflow logs** in the Actions tab
2. **Verify API access** by running the test workflow
3. **Monitor the .last-commit file** to see change detection
4. **Check GitHub Container Registry** for built images

## Security Considerations

- The workflows use the built-in `GITHUB_TOKEN` for authentication
- No secrets are required for basic operation
- The upstream repository is read-only (no write access needed)
- Docker images are built from the official upstream source