# Docker Installation and Setup

tags: #docker

Docker ([[Introduction to Docker]]) is an open-source platform that allows you to build, deploy, and run applications in a containerized environment. In this guide, we will walk you through the steps to install and set up Docker on your system.

## Prerequisites

Before installing Docker, make sure that your system meets the following requirements:

- Operating System: Linux, Windows, or macOS
- CPU architecture: x86_64, armhf, arm64, s390x, ppc64le
- Memory: 2GB RAM
- Disk space: 20GB

## Installing Docker

To install Docker on your system, follow the steps below:

### Linux

1. Update the package index:

   ```
   sudo apt-get update
   ```

2. Install the required dependencies:

   ```
   sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
   ```

3. Add Docker’s official GPG key:

   ```
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
   ```

4. Add the Docker repository:

   ```
   sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
   ```

5. Update the package index again:

   ```
   sudo apt-get update
   ```

6. Install Docker:

   ```
   sudo apt-get install docker-ce docker-ce-cli containerd.io
   ```

7. Verify that Docker is installed correctly:

   ```
   sudo docker version
   ```

### Windows

1. Download the Docker Desktop installer from the Docker website: <https://www.docker.com/products/docker-desktop>

2. Run the installer and follow the instructions to install Docker.

3. Once Docker is installed, open the Docker Desktop application.

4. Verify that Docker is installed correctly:

   ```
   docker version
   ```

### macOS

1. Download the Docker Desktop installer from the Docker website: <https://www.docker.com/products/docker-desktop>

2. Run the installer and follow the instructions to install Docker.

3. Once Docker is installed, open the Docker Desktop application.

4. Verify that Docker is installed correctly:

   ```
   docker version
   ```

## Configuring Docker

After installing Docker, you may want to configure it to suit your needs. Some of the configuration options include:

- Setting up a Docker registry
- Configuring network settings
- Adjusting resource limits
- Configuring Docker Compose

For more information on how to configure Docker, see the official documentation: <https://docs.docker.com/config/>

## Conclusion

In this guide, we have shown you how to install and set up Docker on your system. Docker provides a powerful platform for building, deploying, and running applications in a containerized environment. With Docker, you can streamline your development and deployment process and make your applications more portable and scalable.
