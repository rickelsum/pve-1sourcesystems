## Readme.md

## Updated Specs

* **OS:** Proxmox VE 6.0.4
* **RAM:** 32GB
* **Disk space:**
* *** 2x 1TB Samsung EVO 970 m.2 SSDs (ZFS Raid0 2tb rpool) ***
* *** 4tb Samsung T7 Shield SSD (ZFS single rpool/media) ***
* **GPU:** Nvidia RTX 3070 (passed through to Fedora Silverblue VM)

## Purpose

This server is dedicated to development and testing environments, offering:

* **Containers:** Ideal for running commonly used services on-demand for testing purposes.
* **Podman Pods:** Leverage Podman to run containers with CentOS or Fedora. Traefik, configured as a reverse proxy using your domain (1sourcesystems.au), enables SSL termination for secure container exposure with HTTPS.
* **Databases:** Separate containers for PostgreSQL and CouchDB ensure isolation and improved security.
* **High-end Fedora Silverblue VM:** This VM boasts 12GB of RAM and direct access to the Nvidia RTX 3070 GPU via passthrough, making it perfect for tasks like machine learning model training and GPU-accelerated password cracking with Hashcat.

## Recommendations

* **Separate Database Containers:** Running PostgreSQL and CouchDB in separate containers is generally recommended. This enhances isolation and security by preventing issues in one database from affecting the other.
* **Dedicating the RTX 3070:** While the onboard GPU is currently used for display, consider dedicating the RTX 3070 entirely to the Fedora Silverblue VM. This maximizes performance for your GPU-intensive workloads.

## Additional Notes

* **Container Orchestration:** Explore container orchestration tools like Docker Compose or Podman Compose to simplify deployment, scaling, and updates for your containers.
* **Automatic SSL with Let's Encrypt:** Utilize Let's Encrypt integration with Traefik for automatic certificate generation and renewal, securing your containers with SSL.
* **Firewall Configuration:** Remember to configure firewalls within Proxmox VE and your containers to restrict access to authorized traffic only.

## Getting Started

Many online resources can guide you through setting up your development and testing environment with Proxmox VE, Podman, Traefik, and containerized databases. Here are a few helpful links:

* **Proxmox VE Documentation:** [https://pve.proxmox.com/pve-docs/](https://pve.proxmox.com/pve-docs/)
* **Podman Documentation:** [https://docs.podman.io/en/v4.4/Introduction.html](https://docs.podman.io/en/v4.4/Introduction.html)
* **Traefik Documentation:** [https://doc.traefik.io/traefik/](https://doc.traefik.io/traefik/)
* **PostgreSQL Docker Image:** [https://hub.docker.com/_/postgres](https://hub.docker.com/_/postgres)
* **CouchDB Docker Image:** [https://hub.docker.com/_/couchdb](https://hub.docker.com/_/couchdb)
* **Fedora Silverblue Documentation:** [https://docs.fedoraproject.org/en-US/fedora-silverblue/](https://docs.fedoraproject.org/en-US/fedora-silverblue/)

```
|     Proxmox VE     | (32GB RAM, 2TB ZFS Raid 0)
+--------------------+
          |
          v
+----------------------+
| High-End Fedora VM   | (12GB RAM, Nvidia RTX 3070)
| (Silverblue)          |
| OS: Fedora Silverblue |
| CPU: Dedicated Cores |
| Disk: Allocated from  |
|       ZFS Pool       |
+----------------------+
          |
          v
+-------------------------+  +----------------------+
| Container (Podman)      |  | Container (PostgreSQL) |
| OS: CentOS/Fedora       |  | OS: Linux Distribution |
| CPU: Shared Cores       |  | CPU: Shared Cores       |
| Disk: Overlay on ZFS    |  | Disk: Overlay on ZFS    |
| Memory: Limited         |  | Memory: Limited         |
+-------------------------+  +----------------------+
          |
          v
+-------------------------+
| Container (Traefik)    |
| OS: Linux Distribution |
| CPU: Shared Cores       |
| Disk: Overlay on ZFS    |
| Memory: Limited         |
+-------------------------+
          |
          v
+-------------------------+  +-------------------------+
| Container (CouchDB)    |  +-------------------------+
| OS: Linux Distribution |  | ... (Other Containers)  |
| CPU: Shared Cores       |  | OS: Varied               |
| Disk: Overlay on ZFS    |  | CPU: Shared Cores       |
| Memory: Limited         |  | Disk: Overlay on ZFS    |
+-------------------------+  | Memory: Limited         |
                                 +-------------------------+
        (Network)
         |
+-----------+
| Clients   | (Web Browsers, Development Tools)
+-----------+
```

**Explanation:**

* **Proxmox VE:** The physical server runs Proxmox VE, a virtualization platform that manages VMs and containers.
* **High-End Fedora VM:** This VM has dedicated resources (12GB RAM, Nvidia RTX 3070 GPU) for GPU-intensive tasks like machine learning and password cracking.
* **Containers:** Multiple containers are used for various purposes:
    * **Podman Containers:** These containers can run with CentOS or Fedora for specific development or testing needs.
    * **PostgreSQL Container:** A dedicated container for the PostgreSQL database.
    * **Traefik Container:** This container serves as a reverse proxy using your domain (1sourcesystems.au) and enables SSL termination for secure container access.
    * **CouchDB Container:** A dedicated container for the CouchDB database.
    * **Other Containers (Optional):** Additional containers can be created for other services as needed.
* **Clients:** These represent your web browsers, development tools, or any applications that will interact with the services running in containers or VMs.

**Resource Allocation (Estimates):**

* The specific resource allocation (CPU, memory, disk) for containers can be dynamically adjusted based on your needs. It's recommended to allocate a limited amount of resources to each container to ensure efficient resource utilization.
* The High-End Fedora VM has dedicated access to 12GB of RAM and the Nvidia RTX 3070 GPU.
* Disk space for containers and VMs will be allocated from the available ZFS storage pool.

**Benefits:**

* **Isolation:** Containers provide isolation between services, improving security and stability.
* **Resource Efficiency:** Containers are lightweight and share the host's operating system, making them resource-efficient.
* **Scalability:** You can easily scale your environment by adding or removing containers as needed.
* **Flexibility:** This architecture allows you to run a variety of services for development and testing purposes.

**Additional Notes:**

* Consider using container orchestration tools like Docker Compose or Podman Compose to manage your containers.
* Utilize Let's Encrypt integration with Traefik for automatic SSL certificate generation and renewal.
* Configure firewalls within Proxmox VE and your containers to restrict access to authorized traffic only.

This is a conceptual architecture map, and the specific configuration might vary depending on your specific needs and tools.
