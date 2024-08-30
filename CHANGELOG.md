# Changelog

## 2024-08-30

 * Added `Dockerfile`
   * Added default environment variables as taken from `docker-compose.yml`
   * `ENTRYPOINT`: Changed from `docker-compose.yml`, running in prod mode instead of dev mode
   * Used `COPY` instructions instead of mounting local volumes to ensure easy distribution of container image
 * Added `CHANGELOG.md`
 * Modified `docker-compose.yml`
   * Modified boolean values to be enclosed in quotes, and changed "on / off" references to "true / false"
   * Modified housing-api service
      * Added `build` instruction to build from local Dockerfile
      * Removed use of volumes, in preference of files built into container
      * Removed `entrypoint`, Dockerfile defines appropriate entrypoint already