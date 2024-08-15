# EKS-Cluster-latest

# Creating a Pod in Kubernetes

To create a pod in Kubernetes, follow these steps:

1. **Create a YAML file**: Define a YAML file that describes your pod. For example, create a file named `my-pod.yaml` with the following content:

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: my-pod
    spec:
      containers:
        - name: my-container
          image: nginx
    ```

2. **Apply the configuration**: Save the YAML file and run the following command to create the pod:

    ```bash
    kubectl create -f my-pod.yaml
    ```

   This will create a pod named "my-pod" with an Nginx container.

## Common Pod Commands

Here are some frequently used `kubectl` commands for working with pods:

- **List Pods**: To list all pods in your cluster:

    ```bash
    kubectl get pods
    ```

- **Describe a Pod**: To get detailed information about a specific pod (replace `<pod_name>` with the actual pod name):

    ```bash
    kubectl describe pod <pod_name>
    ```
