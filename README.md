# GPT3.5-turbo discord bot
A containerized discord bot to interact with the OpenAI chat completions API (gpt-3.5-turbo)

## Features

* **Context**: Retains conversation context _up to the set token limit_
* **Discord Limitations**: Splits responses into separate messages to ensure they fit within Discord's 2000 character limit
* **Behavior**: Modify the bot behavior instructions via text files. _See example_convo.txt_

## Run Locally

It is assumed that you have already know how to set-up a discord BOT and have an active bot token before you proceed!

1. Clone this repo locally.  
2. Modify.env.example file to include:  
  - Discord bot token
  - OpenAI API key
  - one or more channel(s) numeric ID

4. Behaviors are stored in the `./prompts` directory.
  - edit the example_convo.txt file to modify the bahavior
  - add multiple examples to expand the bot behaviors
5. Execute the `run_bot.sh` bash script (macOS) to star the service locally

## Deployment

Build the Docker image by running the docker build command in the terminal. Make sure you are in the directory where the Dockerfile is located. For example:

```bash
docker build -t gpt_bot .
```
This will create a Docker image with the name gpt_bot.

Push the Docker image to a container registry, such as Docker Hub or Amazon ECR. You will need to create an account on the registry and log in before pushing the image. For example:

```bash
docker login
docker tag gpt_bot my_registry/gpt_bot
docker push my_registry/gpt_bot
```
Replace `my_registry` with the name of your container registry.

Deploy the Docker image to your preferred platform, such as Kubernetes, Docker Swarm, or AWS ECS. Deployment process will vary depending on the platform you are using.

For this example, we deploy to Google Cloud using Google Kubernetes Engine (GKE):

Set up a GCP project and enable billing for the project.

Install the gcloud command line tool and configure it with your GCP account.

Create a Kubernetes cluster on GKE using the following command:

```lua
gcloud container clusters create my-cluster --num-nodes=1
```

Replace <my-cluster> with a name of your choice.

Build the Docker image using the docker build command:

```bash
docker build -t gpt_bot .
```

Tag the Docker image with a GCP-compatible name using the following command:

```bash
docker tag gpt_bot gcr.io/<PROJECT-ID>/gpt_bot
```

Replace <PROJECT-ID> with your GCP project ID.

Push the Docker image to GCP Container Registry using the following command:

```bash

docker push gcr.io/<PROJECT-ID>/gpt_bot
```
Modify the`example_deployment.yaml`  Kubernetes deployment file with your <PROJECT-ID>:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gpt-bot
spec:
  replicas: 1
  selector:
    matchLabels:
      app: gpt-bot
  template:
    metadata:
      labels:
        app: gpt-bot
    spec:
      containers:
      - name: gpt-bot
        image: gcr.io/<PROJECT-ID>/gpt_bot
        ports:
        - containerPort: 80
```     

Rename the file as `deployment.yaml`.  
Apply the deployment file to your GKE cluster using the following command:


```bash
kubectl apply -f deployment.yaml
```

This will create a Kubernetes deployment running the Docker image you pushed to GCP Container Registry.


Expose the deployment as a Kubernetes service by running the following command:

```bash
kubectl expose deployment gpt-bot --type=LoadBalancer --port 80 --target-port 80
```

This will create a load balancer for your deployment that exposes it on a public IP address.

To get the external IP address of the load balancer using the following command:

```bash
kubectl get service gpt-bot
```