# Getting Started Lab: Permguard + Istio Ambient Mesh

This repository provides a **hands-on lab environment** to demonstrate how **Permguard** can be integrated with **Istio Ambient Mesh**.  
It serves as a **practical reference** for developers experimenting with **policy-based access control (PBAC)** using Permguard, powered by **Istio’s service mesh**.  

## Prerequisites  

Make sure you have the following installed before running the lab:  

- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/)  
- [Permguard CLI](https://github.com/permguard/permguard)
- [Istio CLI](https://istio.io/latest/docs/setup/getting-started/#download)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/)

Optional (depending on what you want to run locally):

- [Go](https://go.dev/dl/) **1.24.6+**  
  > Only required if you want to build/run Go components directly.  
- [Python](https://www.python.org/downloads/) **3.11.8+**  
  > Only required if you plan to run provisioning scripts outside Docker.  

## Project Structure

```md
permguard-keycloak-lab/  
├── docs/                # Documentation and diagrams  
├── ambient-mesh/        # Istio Ambient Mesh setup  
│   └── ...  
├── permguard/           # Permguard setup  
│   └── ...  
└── workspace/           # Permguard workspace
    ├── policies/  
    └── ...  
```

- **istio/** → contains Istio configuration
- **permguard/** → contains Permguard configuration  
- **workspace/** → workspace for Permguard

## Run Locally

Clone the repository and start the environment with Docker Compose:

```bash
git clone git@github.com:ngallo/permguard-istio-ambient-mesh.git
cd permguard-istio-ambient-mesh
make up
```
