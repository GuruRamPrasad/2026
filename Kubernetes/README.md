# Kubernetes Architecture

A clear overview of Kubernetes components, how they communicate, and how an application runs inside a cluster.

## 1. Architecture Diagrams

The first diagram shows the whole cluster in one view. The diagrams after it zoom in on each part in more detail.

### 1.1 Full Architecture

```mermaid
flowchart TB
    U[User / Client] --> LB[Load Balancer]

    subgraph CLUSTER[Kubernetes Cluster]
        subgraph CP[Control Plane]
            SCH[kube-scheduler]
            API[kube-apiserver]
            CM[kube-controller-manager]
            ETCD[(etcd)]
            SCH --> API
            CM --> API
            API <--> ETCD
        end

        subgraph W1[Worker Node 1]
            K1[kubelet]
            P1[kube-proxy]
            POD1["Pod:<br/>Application Container"]
            K1 --> POD1
        end

        ING[Ingress Controller] --> SVC[Service]

        subgraph W2[Worker Node 2]
            K2[kubelet]
            P2[kube-proxy]
            POD2["Pod:<br/>Application Container"]
            K2 --> POD2
        end
    end

    LB --> ING
    ETCD ~~~ ING
    API -. manages .-> K1
    API -. manages .-> K2
    P1 -. implements .-> SVC
    P2 -. implements .-> SVC
    SVC --> POD1
    SVC --> POD2
    POD1 --> DB[("External Database /<br/>Managed Database")]
    POD2 --> DB

    linkStyle 0,5,7,13,14,15,16 stroke:#00A8FF,stroke-width:3px
    linkStyle 1,2,3,4,6 stroke:#00C853,stroke-width:3px
    linkStyle 9,10,11,12 stroke:#FF1744,stroke-width:3px
```

**Arrow colors:** blue = application traffic, green = communication within the control plane or a node, red = control from the API server to nodes.

> **Note:** This is a conceptual diagram. Ingress controllers, cloud load balancers, and database services are optional and depend on the cluster design. Solid arrows show application traffic: User → Load Balancer → Ingress Controller → Service → Pods → Database. Dotted arrows show control, not traffic. The API server manages each node's kubelet, which starts and monitors the Pods. kube-proxy gets Service information from the API server and *implements* the Service by programming networking rules on its node. The Service has no direct connection to the API server, and application traffic never passes through the API server.

### 1.2 Control Plane

```mermaid
flowchart TB
    ADMIN["kubectl / CI-CD / GitOps"]

    subgraph CP["Control Plane"]
        SCH["kube-scheduler"]
        CM["kube-controller-manager"]
        CCM["cloud-controller-manager<br/>(optional)"]
        API["kube-apiserver<br/>authentication → authorization → admission"]
        ETCD[("etcd")]
    end

    CLOUD["Cloud Provider API<br/>(load balancers, nodes, routes)"]
    NODES["Worker Nodes<br/>(kubelet, kube-proxy)"]

    ADMIN -->|"requests"| API
    SCH <-->|"watch Pods / bind"| API
    CM <-->|"watch / update"| API
    CCM <-->|"watch / update"| API
    CCM -->|"calls"| CLOUD
    API <-->|"read / write state"| ETCD
    API <-->|"Pod specs / status"| NODES

    linkStyle 0 stroke:#00A8FF,stroke-width:3px
    linkStyle 1,2,3,5 stroke:#00C853,stroke-width:3px
    linkStyle 6 stroke:#FF1744,stroke-width:3px
    linkStyle 4 stroke:#E040FB,stroke-width:3px
```

**Arrow colors:** blue = user and tool requests, green = communication within the control plane, red = API server to worker nodes, pink = calls to external systems.

The **kube-apiserver** is the hub of the cluster. Every component talks to it, and none of them talk to each other directly.

- **Every request** goes through authentication, authorization (e.g. RBAC) and admission control before anything is saved.
- **etcd** is read and written only by the API server.
- **kube-scheduler** watches for Pods with no node assigned, picks a node, and writes that choice (a *binding*) back through the API server.
- **kube-controller-manager** watches objects through the API server and updates them to match the desired state, e.g. creating Pods for a ReplicaSet.
- **cloud-controller-manager** (cloud clusters only) watches the API server and calls the cloud provider's API to create load balancers, manage nodes and set up routes.
- **Worker nodes** (kubelet and kube-proxy) also connect to the API server. Section 1.3 shows them in detail.

### 1.3 Worker Node

```mermaid
flowchart TB
    API["kube-apiserver<br/>(control plane)"]
    REG[("Container Registry")]

    subgraph NODE["Worker Node"]
        K["kubelet"]
        KP["kube-proxy"]
        CR["Container runtime<br/>(containerd / CRI-O)"]
        CNI["CNI plugin<br/>(Pod networking)"]
        P1["Pod"]
        P2["Pod"]
    end

    API <-->|"Pod specs / status"| K
    API -->|"Service info"| KP
    K -->|"CRI: run containers"| CR
    CR -.->|"pull images"| REG
    CR -->|"set up network"| CNI
    CR --> P1
    CR --> P2
    CNI -.->|"Pod IPs"| P1
    CNI -.->|"Pod IPs"| P2
    KP -.->|"Service routing rules"| P1
    KP -.->|"Service routing rules"| P2

    linkStyle 9,10 stroke:#00A8FF,stroke-width:3px
    linkStyle 2,4,5,6,7,8 stroke:#00C853,stroke-width:3px
    linkStyle 0,1 stroke:#FF1744,stroke-width:3px
    linkStyle 3 stroke:#E040FB,stroke-width:3px
```

**Arrow colors:** blue = Service traffic routing, green = communication within the node, red = control from the API server, pink = calls to external systems.

Every worker node runs these same components:

- **kubelet** gets the specs of Pods assigned to its node from the API server and reports node and Pod status back. It runs health probes and tells the container runtime what to run, through the Container Runtime Interface (CRI).
- **Container runtime** pulls images from the registry and starts the containers that make up each Pod. When it creates a Pod, it calls the CNI plugin to set up networking.
- **CNI plugin** gives each Pod its own IP address and connects it to the cluster network.
- **kube-proxy** gets Service and EndpointSlice information from the API server and programs the node's networking rules (iptables, IPVS or nftables), so traffic sent to a Service reaches the right Pods.

### 1.4 Traffic Flow

```mermaid
flowchart TB
    USER["User / Client"]
    LB["Cloud Load Balancer<br/>(optional)"]
    ING["Ingress Controller / Gateway<br/>(optional)"]
    SVC["Service<br/>(stable IP + DNS name)"]
    P1["Pod 1"]
    P2["Pod 2"]
    P3["Pod 3"]
    DB[("Database")]

    USER --> LB --> ING --> SVC
    SVC --> P1
    SVC --> P2
    SVC --> P3
    P1 --> DB
    P2 --> DB
    P3 --> DB
```

> **Note:** These are conceptual diagrams. Ingress controllers, Gateway implementations, cloud load balancers, and external databases are optional and depend on the cluster design. A Service is a virtual object, not a running process. kube-proxy (or a replacement such as an eBPF-based CNI) programs each node so that traffic sent to the Service reaches one of its **ready** Pods.

## 2. What Is Kubernetes?

Kubernetes (K8s) is an open-source container orchestration platform originally designed by Google and now maintained by the Cloud Native Computing Foundation (CNCF). It helps deploy, scale, and manage containerized applications across a group of machines called a **cluster**.

A Kubernetes cluster is made up of:
- **Control plane** — makes cluster-wide decisions (such as scheduling), stores cluster state, and detects and responds to changes.
- **Worker nodes** — run application Pods.

Kubernetes is **declarative**: you describe the *desired state* (for example, "run 3 replicas of this image"), and controllers continually work to make the *actual state* match it. This loop is called **reconciliation**.

## 3. Control Plane Components

| Component | Responsibility |
|---|---|
| **kube-apiserver** | Front end of the control plane and the only component that reads from and writes to etcd. Handles authentication, authorization (e.g. RBAC), and admission control for every request. `kubectl`, controllers, the scheduler, and kubelets all communicate through it. Scales horizontally. |
| **etcd** | Consistent, highly available distributed key-value store that holds all cluster state and configuration. Uses the Raft consensus algorithm, so it is usually run with an odd number of members (3 or 5) to maintain quorum. |
| **kube-scheduler** | Watches for newly created Pods with no assigned node and selects a suitable node based on resource requests, node selectors, affinity/anti-affinity, taints and tolerations, and topology spread constraints. It only *assigns* the node; the kubelet starts the Pod. |
| **kube-controller-manager** | Runs built-in controllers (Deployment, ReplicaSet, Node, Job, EndpointSlice, ServiceAccount, and others) that continually compare actual state with desired state and take corrective action. |
| **cloud-controller-manager** *(optional)* | Integrates Kubernetes with a cloud provider: provisions cloud load balancers for `LoadBalancer` Services, manages node lifecycle, and configures routes. Not present in most on-premises or local clusters. |

## 4. Worker Node Components

| Component | Responsibility |
|---|---|
| **kubelet** | Node agent that registers the node with the API server, watches for Pods assigned to it, and ensures their containers are running and healthy (including running probes). Reports node and Pod status back to the API server. |
| **Container runtime** | Pulls images and runs containers through the Container Runtime Interface (CRI). Common runtimes are **containerd** and **CRI-O**. Direct Docker Engine support (dockershim) was removed in Kubernetes 1.24, though images built with Docker still run normally. |
| **kube-proxy** *(common, but not universal)* | Watches Services and EndpointSlices and programs node networking rules (iptables, IPVS, or nftables) so Service traffic reaches the right Pods. Some CNI plugins, such as Cilium, can replace it entirely. |
| **CNI plugin** | Provides Pod networking so every Pod gets its own IP and can reach every other Pod without NAT. Examples: Calico, Cilium, Flannel, and cloud-specific plugins such as the AWS VPC CNI. |

**Pods** are not a node component themselves, but they run on worker nodes. A Pod is the smallest deployable Kubernetes unit and contains one or more closely related containers that share a network namespace (IP address and ports) and can share storage volumes.

### Common Cluster Add-ons

| Add-on | Responsibility |
|---|---|
| **CoreDNS** | Cluster DNS. Gives Services DNS names such as `my-svc.my-namespace.svc.cluster.local`. |
| **metrics-server** | Collects CPU and memory usage from kubelets. Required for `kubectl top` and for the Horizontal Pod Autoscaler using resource metrics. |
| **Ingress controller / Gateway implementation** | Implements Ingress or Gateway API routing rules (e.g. NGINX-based controllers, Traefik, HAProxy, Envoy Gateway, cloud provider controllers). |
| **CSI drivers** | Container Storage Interface drivers that let Kubernetes provision and attach storage from cloud or on-premises storage systems. |

## 5. Important Kubernetes Objects

### Workloads
- **Pod:** Runs one or more containers. Usually created by a higher-level controller rather than directly.
- **Deployment:** Manages replicated stateless Pods and supports rolling updates and rollbacks.
- **ReplicaSet:** Keeps the requested number of Pod replicas running; usually managed by a Deployment.
- **StatefulSet:** Manages stateful Pods that need stable network identities, ordered startup/shutdown, and per-replica persistent storage (e.g. databases, Kafka).
- **DaemonSet:** Runs one copy of a Pod on every (or selected) node — commonly used for log collectors, monitoring agents, and CNI components.
- **Job / CronJob:** Runs tasks to completion once or on a schedule.

### Networking
- **Service:** Provides a stable virtual IP and DNS name and load-balances traffic to matching, ready Pods. Main types:
  - `ClusterIP` (default) — reachable only inside the cluster.
  - `NodePort` — exposes the Service on a static port on every node.
  - `LoadBalancer` — provisions an external load balancer (usually via the cloud provider).
  - `ExternalName` — maps the Service to an external DNS name.
- **Ingress:** Defines HTTP/HTTPS routing rules (host- and path-based routing, TLS termination); requires an Ingress controller to implement them. The Ingress API is stable but frozen — new features go into the Gateway API.
- **Gateway API:** The newer, more expressive successor to Ingress (`GatewayClass`, `Gateway`, `HTTPRoute`, and other route types), with clearer role separation between infrastructure and application teams.
- **NetworkPolicy:** Controls which Pods can communicate with each other and with external endpoints. Only enforced if the CNI plugin supports it.

### Configuration and Storage
- **ConfigMap:** Stores non-sensitive configuration.
- **Secret:** Stores sensitive configuration data. By default, Secret values are only **base64-encoded, not encrypted**, in etcd. Enable encryption at rest, restrict access with RBAC, and consider an external secret manager; a Secret is not automatically secure just because it is a Kubernetes object.
- **PersistentVolume (PV) / PersistentVolumeClaim (PVC):** Represent and request persistent storage.
- **StorageClass:** Defines a class of storage and enables dynamic provisioning of PVs when a PVC is created.

### Cluster Organization and Access
- **Namespace:** Organizes and isolates resources within a cluster; many policies (RBAC, quotas) are namespace-scoped.
- **ServiceAccount:** Identity used by Pods when they talk to the API server.
- **Role / ClusterRole and RoleBinding / ClusterRoleBinding (RBAC):** Grant permissions to users, groups, and ServiceAccounts.
- **ResourceQuota / LimitRange:** Limit total resource usage per namespace and set default requests/limits for containers.

### Scaling and Availability
- **HorizontalPodAutoscaler (HPA):** Scales the number of Pod replicas based on metrics such as CPU, memory, or custom metrics.
- **PodDisruptionBudget (PDB):** Limits how many Pods of an application can be down at once during voluntary disruptions such as node drains.

## 6. How an Application Runs

1. A developer builds a container image and pushes it to a container registry.
2. A Deployment manifest is applied using `kubectl`, a CI/CD pipeline, or GitOps tooling (e.g. Argo CD, Flux).
3. The request reaches the **kube-apiserver**, which authenticates and authorizes it, runs admission controllers, validates the object, and stores the desired state in **etcd**.
4. The **Deployment controller** (in kube-controller-manager) notices the new Deployment and creates a **ReplicaSet**.
5. The **ReplicaSet controller** creates the required number of **Pod** objects. At this point the Pods exist in the API but are not yet assigned to a node (status `Pending`).
6. The **kube-scheduler** selects a suitable worker node for each unscheduled Pod and records that assignment (binding) through the API server.
7. The **kubelet** on the chosen node sees the Pod assigned to it and asks the **container runtime** to pull the image and start the containers. The CNI plugin gives the Pod an IP address.
8. The kubelet runs the configured startup, liveness, and readiness probes and reports Pod status back to the API server.
9. Once a Pod is **Ready**, the EndpointSlice controller adds it to the Service's endpoints, and kube-proxy (or its replacement) updates node rules so the **Service** routes traffic to it. External traffic may enter through a cloud load balancer and/or an Ingress controller or Gateway, depending on the setup.
10. Controllers keep reconciling: if a Pod or node fails, the ReplicaSet controller creates a replacement Pod to maintain the desired replica count, and the scheduler places it on a healthy node.

## 7. Request Flow (Simplified)

```text
Client
  |
  v
DNS resolves the application hostname
  |
  v
Cloud Load Balancer (if configured)
  |
  v
Ingress Controller / Gateway (if configured)
  |
  v
Service (ClusterIP virtual IP, implemented by kube-proxy or CNI)
  |
  +------> Pod replica 1  (only Pods that are Ready receive traffic)
  |
  +------> Pod replica 2
  |
  +------> Pod replica 3
```

Ingress is not mandatory. For example, a `LoadBalancer` Service can expose an application directly through a cloud load balancer, a `NodePort` Service exposes it on a port of every node, and a `ClusterIP` Service is reachable only inside the cluster by default.

Inside the cluster, Pods typically reach each other through Service DNS names (resolved by CoreDNS), for example `http://backend.my-namespace.svc.cluster.local`.

## 8. High Availability and Scaling

- Run control-plane components across multiple machines (commonly three) for a highly available control plane where supported. Managed services (EKS, GKE, AKS) handle this for you.
- Run etcd with an odd number of members (3 or 5) so it can tolerate failures while keeping quorum.
- Use multiple worker nodes and spread replicas across nodes or zones using pod anti-affinity or topology spread constraints.
- Set resource requests and limits for containers so the scheduler can place Pods correctly and noisy neighbors are contained.
- Configure readiness, liveness, and startup probes appropriately.
- Use a Horizontal Pod Autoscaler (HPA) to scale Pod replicas when metrics and workload configuration support it (requires metrics-server or another metrics source).
- Use the Cluster Autoscaler or Karpenter to add and remove nodes based on pending Pods; consider the Vertical Pod Autoscaler (VPA) to right-size requests.
- Use PodDisruptionBudgets to help limit voluntary disruptions.
- Back up `etcd` (and application data in persistent volumes, e.g. with Velero) and regularly test cluster recovery procedures.
- Monitor cluster and application health using tools such as Prometheus and Grafana, and centralize logs (e.g. Loki, Elasticsearch/OpenSearch, or Fluent Bit forwarding to a log backend).

## 9. Security Basics

- Use **RBAC** with least-privilege permissions for users and ServiceAccounts.
- Enforce **Pod Security Standards** (Privileged / Baseline / Restricted) with Pod Security Admission.
- Restrict Pod-to-Pod traffic with **NetworkPolicies**.
- Enable **encryption at rest** for Secrets and protect access to etcd.
- Run containers as non-root, with read-only root filesystems where possible.
- Scan images for vulnerabilities and pull only from trusted registries.
- Keep the cluster version up to date; each Kubernetes minor release is supported for roughly 14 months.

## 10. Useful Commands

```bash
# View cluster nodes
kubectl get nodes -o wide

# View namespaces
kubectl get namespaces

# View Pods across all namespaces
kubectl get pods -A -o wide

# View Deployments and Services in the current namespace
kubectl get deployments,services

# Apply a manifest (create or update resources)
kubectl apply -f deployment.yaml

# Watch a rollout and roll back if needed
kubectl rollout status deployment/<deployment-name>
kubectl rollout undo deployment/<deployment-name>

# Scale a Deployment
kubectl scale deployment/<deployment-name> --replicas=3

# Inspect a Pod
kubectl describe pod <pod-name>

# View container logs (-c for a specific container, --previous for a crashed container)
kubectl logs <pod-name>
kubectl logs <pod-name> -c <container-name> --previous

# Open a shell inside a running container
kubectl exec -it <pod-name> -- sh

# Forward a local port to a Pod or Service for testing
kubectl port-forward svc/<service-name> 8080:80

# View resource usage (requires metrics-server)
kubectl top nodes
kubectl top pods

# View recent events
kubectl get events --sort-by=.metadata.creationTimestamp

# View control-plane and core service endpoints
kubectl cluster-info

# View the current kubeconfig context
kubectl config current-context
```

## 11. Summary

The **control plane** stores the desired state of the cluster and decides what should run and where. **Worker nodes** run Pods using the kubelet and a container runtime. Kubernetes controllers continually reconcile the actual cluster state with the desired state, the scheduler places Pods on nodes, and Services (with optional Ingress or Gateway API) provide stable networking for application Pods.

---

**Tip:** GitHub renders Mermaid diagrams in Markdown files. If your Markdown viewer does not support Mermaid, use the text-based request-flow diagram in Section 7.
