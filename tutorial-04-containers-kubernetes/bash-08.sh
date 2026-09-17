#!/usr/bin/env bash
set -euo pipefail

1. Write Code
        |
        v
2. Write Dockerfile
   docker build -t my-app:${GIT_SHA} .
        |
        v
3. Test the Image
   docker run --rm my-app:${GIT_SHA} pytest
        |
        v
4. Push to Registry
   docker push myregistry/my-app:${GIT_SHA}
        |
        v
5. Update Kubernetes Manifest
   (set image tag to ${GIT_SHA})
        |
        v
6. Apply to Staging
   kubectl apply -f k8s/ -n staging
   kubectl rollout status deployment/my-app -n staging
        |
        v
7. Run Integration Tests Against Staging
        |
        v
8. Apply to Production
   kubectl apply -f k8s/ -n production
   kubectl rollout status deployment/my-app -n production
        |
        v
9. Monitor
   kubectl get pods -n production
   kubectl logs -f -n production -l app=my-app
