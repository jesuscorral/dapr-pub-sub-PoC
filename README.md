# Dapr Pub/Sub PoC

This project is a Proof of Concept (PoC) based on Dapr's Pub/Sub capabilities. It demonstrates how to use Dapr to implement a publish-subscribe messaging pattern in a .NET application.

## Project Structure

The project consists of two main applications:
- **Pub**: The publisher application that sends messages.
- **Sub**: The subscriber application that receives messages.

Additionally, the project includes infrastructure as code (IaC) to deploy the necessary resources in Azure.

## Infrastructure

The infrastructure is defined using Bicep and includes the following components:
- **Azure Service Bus**: Used as the message broker for the Pub/Sub pattern.
- **Azure Container Apps**: Used to host the Pub and Sub applications.
- **Azure Application Insights**: Used for monitoring and logging.
- **Azure Log Analytics Workspace**: Used for storing logs and metrics.

## Deployment

The deployment is managed using Bicep templates located in the `Infrastructure` folder. The main deployment file is `main.bicep`, which orchestrates the deployment of all resources.

## Prerequisites

Before you can deploy and run the project, ensure you have the following:
- An Azure subscription
- Azure CLI installed
- Docker installed
- .NET SDK installed

## Steps to Deploy and Run

1. **Clone the repository**:
    ```sh
    git clone https://github.com/your-repo/dapr-pub-sub-PoC.git
    cd dapr-pub-sub-PoC
    ```

2. **Login to Azure**:
    ```sh
    az login
    ```

3. **Create a resource group**:
    ```sh
    az group create --name myResourceGroup --location eastus
    ```

4. **Deploy the infrastructure**:
    ```sh
    az deployment group create --resource-group myResourceGroup --template-file Infrastructure/main.bicep
    ```

5. **Build and publish the Docker images**:
    ```sh
    cd Pub
    docker build -t your-dockerhub-username/pub .
    docker push your-dockerhub-username/pub
    cd ../Sub
    docker build -t your-dockerhub-username/sub .
    docker push your-dockerhub-username/sub
    ```

6. **Update the Bicep template with your Docker image names**:
    - Update [main.bicep](http://_vscodecontentref_/1) with your Docker image names for the Pub and Sub applications.

7. **Redeploy the infrastructure**:
    ```sh
    az deployment group create --resource-group myResourceGroup --template-file Infrastructure/main.bicep
    ```

8. **Run the applications locally**:
    - Start the Dapr sidecar for the Pub application:
        ```sh
        dapr run --app-id pub --app-port 5000 -- dotnet run --project Pub/Pub.csproj
        ```
    - Start the Dapr sidecar for the Sub application:
        ```sh
        dapr run --app-id sub --app-port 7006 -- dotnet run --project Sub/Sub.csproj
        ```

## Conclusion

This PoC demonstrates how to use Dapr's Pub/Sub capabilities to build a scalable and reliable messaging system. By leveraging Azure services and Dapr, you can easily deploy and manage your applications in the cloud.