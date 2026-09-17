import sys

def deploy():
    try:
        run_deployment_steps()
    except DeploymentError as e:
        log.error(f"Deployment failed: {e}")
        log.info("Initiating rollback...")
        rollback()
        sys.exit(1)
    except KeyboardInterrupt:
        log.warning("Deployment interrupted by user. Cleaning up...")
        cleanup()
        sys.exit(130)
