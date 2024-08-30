# Question 2:
   2. To run prebuilt docker image locally, you can run `docker run --name sample-api -p 3003:3000 ghcr.io/vancwo/sample-api:main`
      1. This will start the application on your local machine, running on port 3003
   3. Successful run: https://github.com/vancwo/sample-api/actions/runs/10638302390/job/29493971037
   4. If you'd like to trigger the workflow yourself, fork this repository. Push a new commit to your forked repository, and a GitHub workflow will be triggered to build and push a new multi-arch docker image.
   5. Please check `CHANGELOG.md` to see added and changed files

# Question 3:

Note: I don't have experience with OpenShift, but from what I gather it's Kubernetes with batteries included.

To create a test environment for this API, I would create a helm chart to define all necessary components to deploy.

First, to create the database server and begin the database cloning process, the Crunchy Postgres for Kubernetes Operator provides facilities for database creation and cloning. You can define a `PostgresCluster` resource that tells the operator to create a Postgres DB, using the production Postgres DB as the `dataSource`. I would include this resource in my helm templates. Note that it's possible to use databases in other namespaces as the source of your clone.

Next, I would define a deployment file for the `sample-api` container. This would handle the deployment of the API service. In this deployment, I would include the flyway migration container as an `initContainer`. This ensures that database migrations are always ran before upgrades. If there's concerns about prior versions of the application continuing to run when the migration is ongoing, I would set the deployment's `.spec.strategy.type` to `Recreate` to ensure any existing pods are killed before new ones are created.

Finally, I would define any necessary networking components, depending on the environment. This could include defining `Ingress` and `Service` resources to allow external connectivity.

Once the helm chart is complete, it could be deployed to the OpenShift cluster. Once installed, the database server would be created, a clone of the production database would be performed, flyway migrations would be ran, then finally the api server would be started.

There's also several improvements to this test environment that could be made in the future. For instance, flyway could run as a helm `pre-install` / `pre-upgrade` hook, so that it's only run once during installs / upgrades rather than as an initContainer for each pod that spins up. It's debatable whether this is desirable, as many people dislike the use of hooks in favor of fast idempotent initContainers. Proper RBAC could also be included as needed.