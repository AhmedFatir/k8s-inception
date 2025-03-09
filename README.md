# k8s-inception

* This project sets up a [**Kubernetes**](https://kubernetes.io/) environment to deploy a [**WordPress**](https://wordpress.org/) site with a [**MariaDB**](https://mariadb.org/) database and an [**Nginx**](https://nginx.org/) reverse proxy.
* The setup includes the necessary deployments, services, secrets, and persistent volume claims.

## Requirements
* Kubernetes cluster (v1.19+)
* kubectl CLI tool
* Access to container registry (for custom images)

## Architecture

```
            ┌─────────┐ 80/443 ┌─────────┐ SVC ┌───────────┐ SVC ┌─────────┐
            │  Client │───────▶│  Nginx  │────▶│ WordPress │────▶│ MariaDB │
            └─────────┘        │  (LB)   │     │   (App)   │     │  (DB)   │
                               └─────────┘     └───────────┘     └─────────┘
                                    │                │                │
                                    │                │                │
                                    ▼                ▼                ▼
                                ┌─────────┐     ┌───────────┐     ┌─────────┐
                                │  Nginx  │     │ WordPress │     │ MariaDB │
                                │   PVC   │     │   PVC     │     │   PVC   │
                                └─────────┘     └───────────┘     └─────────┘
```

## Project Structure
   
### Deployments

- **WordPress**: Defined in [k8s/Deployments/wordpress.yml](k8s/Deployments/wordpress.yml)
- **Nginx**: Defined in [k8s/Deployments/nginx.yml](k8s/Deployments/nginx.yml)

### StatefulSets

- **MariaDB**: Defined in [k8s/StatefulSets/maridb.yml](k8s/StatefulSets/maridb.yml)

### Services

- **MariaDB Service**: Defined in [k8s/Services/mariadb-svc.yml](k8s/Services/mariadb-svc.yml)
- **WordPress Service**: Defined in [k8s/Services/wordpress-svc.yml](k8s/Services/wordpress-svc.yml)
- **Nginx Service**: Defined in [k8s/Services/nginx-svc.yml](k8s/Services/nginx-svc.yml)

### Environment Configurations

- **MariaDB Secret**: Defined in [k8s/Env/mdb-secret.yml](k8s/Env/mdb-secret.yml)
- **WordPress Secret**: Defined in [k8s/Env/wp-secret.yml](k8s/Env/wp-secret.yml)
- **Nginx ConfigMap**: Defined in [k8s/Env/nginx-config.yml](k8s/Env/nginx-config.yml)

### Persistent Volume Claims

- **MariaDB PVC**: Defined in [k8s/Volumes/mariadb-pvc.yml](k8s/Volumes/mariadb-pvc.yml)
- **WordPress PVC**: Defined in [k8s/Volumes/wordpress-pvc.yml](k8s/Volumes/wordpress-pvc.yml)
- **Nginx Certificates PVC**: Defined in [k8s/Volumes/nginx-pvc.yml](k8s/Volumes/nginx-pvc.yml)


## Makefile Commands
* Deploy all resources
```
make
```
* Clean up all resources
```
make clean
```
* Recreate all resources:
```
make re
```

## Usage
1. Ensure you have [**kubectl**]() installed and configured to interact with your [**Kubernetes cluster**]().
2. Run `make` to deploy the environment.
3. Access the WordPress site through the Nginx load balancer.

## Notes
* The Nginx configuration redirects `HTTP` traffic to `HTTPS` and proxies requests to the WordPress service.
* Secrets are `base64` encoded and stored in Kubernetes secrets for security.
* Persistent volume claims ensure data persistence for MariaDB and WordPress.