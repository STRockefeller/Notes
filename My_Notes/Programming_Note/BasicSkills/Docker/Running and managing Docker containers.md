# Running and managing Docker containers

#docker

Docker ([[Introduction to Docker]]) is an open-source containerization platform that enables developers to package and run applications in isolated environments called containers. Containers provide a lightweight and portable way to deploy applications, and they can run on any platform that supports Docker.

In this document, we will discuss how to run and manage Docker containers.

## Prerequisites

Before you can run Docker containers, you must have Docker installed on your system.(refer to [[Docker Installation and Setup]]) You can download and install Docker from the official Docker website.

Read [[Docker Images and Containers]] first.

## Running a Docker container

To run a Docker container, you must first create an image of the application you want to run. An image is a template that contains all the necessary files and dependencies for the application to run.

To create an image, you can use a Dockerfile, which is a script that contains instructions for building the image. Once you have created the image, you can use the `docker run` command to start a container from the image.

For example, if you have an image called `myapp` and you want to start a container from it, you can use the following command:

```
docker run myapp
```

This command will start a new container from the `myapp` image.

## Managing Docker containers

Once you have started a Docker container, you can manage it using various Docker commands.

### Viewing running containers

To view a list of all the running containers on your system, you can use the `docker ps` command.

```
docker ps
```

This command will display a list of all the running containers on your system, along with their container ID, image name, and status.

### Stopping a container

To stop a running container, you can use the `docker stop` command, followed by the container ID or name.

```
docker stop <container-id>
```

This command will stop the container with the specified ID.

### Removing a container

To remove a stopped container from your system, you can use the `docker rm` command, followed by the container ID or name.

```
docker rm <container-id>
```

This command will remove the container with the specified ID from your system.

## Conclusion

Docker provides a powerful and flexible platform for running and managing containers. By following the instructions in this document, you should be able to run and manage Docker containers on your system with ease.
