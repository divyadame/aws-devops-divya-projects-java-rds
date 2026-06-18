
```
my-project-repo/
├── .github/workflows/
│   ├── deploy-frontend.yml
│   └── deploy-backend-api.yml
├── .aws/
│   ├── frontend-task-def.json   <-- Unique settings for Frontend
│   └── backend-task-def.json    <-- Unique settings for Backend API
├── frontend-app-code/
└── backend-api-code/
```
Why Each Microservice Needs Its Own Task Definition
•	Independent Deployment: If you change code in the backend API, you only want to rebuild and redeploy the backend. Giving each app its own Task Definition allows GitHub Actions to update one service without touching or restarting the others. [1]
•	Independent Scaling: Your frontend service might experience high traffic and require 10 container tasks, while an internal reporting microservice might only ever need 1. Separate Task Definitions allow them to scale completely independently. [1, 2, 3]
•	Isolated Resources: A resource-heavy data processing microservice might need 4 vCPUs and 8GB of memory, while a simple web server might only need 0.5 vCPUs. You specify these resource limits at the Task Definition level. [1, 2]
•	Granular Security (IAM Roles): Your payment microservice needs access to a secure payment database, but your frontend microservice shouldn't have that access. Separate Task Definitions allow you to assign distinct Task Roles to each microservice. [1, 2]
________________________________________

