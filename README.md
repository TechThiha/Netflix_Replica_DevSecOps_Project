# Netflix Clone DevSecOps Project

<div align="center">
  <a href="http://netflix-clone-with-tmdb-using-react-mui.vercel.app/">
    <img src="./public/assets/netflix-logo.png" alt="Logo" width="100" height="32">
  </a>
  <h3 align="center">Netflix Clone</h3>
  <p align="center">
    <a href="http://netflix.privategamehost.com/">View Demo</a>
    ·
    <a href="https://github.com/crazy-man22/netflix-clone-react-typescript/issues">Report Bug</a>
    ·
    <a href="https://github.com/crazy-man22/netflix-clone-react-typescript/issues">Request Feature</a>
  </p>
</div>

This project demonstrates a comprehensive CI/CD pipeline for a Netflix clone application, incorporating various DevSecOps practices and tools.

<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#tools-and-technologies">Tools and Technologies</a></li>
    <li><a href="#project-overview">Project Overview</a></li>
    <li><a href="#key-features">Key Features</a></li>
    <li><a href="#getting-started">Getting Started</a></li>
    <li><a href="#pipeline-stages">Pipeline Stages</a></li>
    <li><a href="#prerequests">Prerequests</a></li>
    <li><a href="#which-features-this-project-deals-with">Which features this project deals with</a></li>
    <li><a href="#third-party-libraries-used">Third Party Libraries Used</a></li>
    <li><a href="#install-with-docker">Install with Docker</a></li>
    <li><a href="#todo">Todo</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>

## Tools and Technologies

- Terraform (Infrastructure as Code)
- AWS (Cloud Provider)
- Azure (Cloud Provider)
- Kubernetes (K8s) for container orchestration
- Jenkins for continuous integration and delivery
- Java (OpenJDK 17) as the programming language
- Docker and Docker Compose for containerization
- Trivy for vulnerability scanning
- Kubectl for Kubernetes cluster management
- SonarQube for code quality analysis
- TMDB API (The Movie Database API) for content data
- Grafana for monitoring and visualization
- Prometheus for metrics collection and alerting

## Project Overview

This project outlines a comprehensive CI/CD pipeline for a Netflix clone. It details the steps to set up the development environment, configure essential tools, and implement robust security and monitoring solutions.

## Key Features

- Automated infrastructure provisioning using Terraform
- Continuous Integration and Deployment (CI/CD) with Jenkins
- Code quality assessment via SonarQube
- Security scanning using Trivy and OWASP Dependency-Check
- Application containerization with Docker
- Integration with Amazon Elastic Container Registry (ECR)
- Container orchestration through Kubernetes
- System monitoring and data visualization using Grafana and Prometheus

## Getting Started

1. Clone this repository
2. Set up the required tools (Jenkins, Docker, Kubernetes, etc.)
3. Configure Jenkins with the necessary plugins and credentials
4. Set up SonarQube and configure it in Jenkins
5. Create a TMDB API key and add it to your Jenkins credentials
6. Set up Grafana and Prometheus for monitoring
7. Run the Jenkins pipeline

For detailed setup instructions, please refer to the project documentation.

## Pipeline Stages

1. Workspace Cleanup and Code Checkout
2. SonarQube Analysis
3. Quality Gate Check
4. Node.js Dependencies Installation
5. OWASP Dependency Check
6. Trivy File System Scan
7. Docker Build and Push
8. Trivy Image Scan
9. Deployment to Docker container
10. Deployment to Kubernetes cluster

## Prerequests

- Create an account if you don't have on [TMDB](https://www.themoviedb.org/). Because I use its free API to consume movie/tv data.
- And then follow the [documentation](https://developers.themoviedb.org/3/getting-started/introduction) to create API Key
- Finally, if you use v3 of TMDB API, create a file named `.env`, and copy and paste the content of `.env.example`. And then paste the API Key you just created.

## Which features this project deals with

- How to create and use [Custom Hooks](https://reactjs.org/docs/hooks-custom.html)
- How to use [Context](https://reactjs.org/docs/context.html) and its provider
- How to use lazy and Suspense for [Code-Splitting](https://reactjs.org/docs/code-splitting.html)
- How to use a new [lazy](https://reactrouter.com/en/main/route/lazy) feature of react-router to reduce bundle size.
- How to use data [loader](https://reactrouter.com/en/main/route/loader) of react-router, and how to use redux dispatch in the loader to fetch data before rendering component.
- How to use [Portal](https://reactjs.org/docs/portals.html)
- How to use [Fowarding Refs](https://reactjs.org/docs/forwarding-refs.html) to make components reusuable
- How to create and use [HOC](https://reactjs.org/docs/higher-order-components.html)
- How to customize default theme of [MUI](https://mui.com/)
- How to use [RTK](https://redux-toolkit.js.org/introduction/getting-started)
- How to use [RTK Query](https://redux-toolkit.js.org/rtk-query/overview)
- How to customize default classname of [MUI](https://mui.com/material-ui/experimental-api/classname-generator)
- Infinite Scrolling(using [Intersection Observer API](https://developer.mozilla.org/en-US/docs/Web/API/Intersection_Observer_API))
- How to make awesome carousel using [slick-carousel](https://react-slick.neostack.com)

## Third Party Libraries Used

- [react-router-dom@v6.9](https://reactrouter.com/en/main)
- [MUI(Material UI)](https://mui.com/)
- [framer-motion](https://www.framer.com/docs/)
- [video.js](https://videojs.com)
- [react-slick](https://react-slick.neostack.com/)

## Install with Docker

```
docker build --build-arg TMDB_V3_API_KEY=your_api_key_here -t netflix-clone .
docker run --name netflix-clone-website --rm -d -p 80:80 netflix-clone
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgements

This project was created by [HenOps](https://mm.linkedin.com/in/thiha-zaw-b25024250). It draws inspiration from two primary sources:

- A comprehensive Medium tutorial on implementing CI/CD pipelines by [Kwasi Twum-Ampofo (KTA)](https://medium.com/@cloudoers)
- An open-source Netflix clone project by [Jason](https://github.com/jason-liu22), which provided the foundation for our application

I'm grateful for these resources and their significant contributions to this educational DevSecOps demonstration. Special thanks to Kwasi and Jason for their invaluable contributions to the codebase.