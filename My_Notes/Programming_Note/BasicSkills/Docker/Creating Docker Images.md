# Creating Docker Images

tags: #docker

Docker is a containerization platform that enables developers to package their applications into containers. A Docker container is a lightweight, standalone, and executable package that includes everything needed to run an application, such as code, dependencies, and system libraries. In this guide, we will walk you through the process of creating Docker images.

## Prerequisites

[[Docker Installation and Setup]]

## Steps

1. **Create a Dockerfile**: A Dockerfile is a script that contains a set of instructions used to build a Docker image. To create a Dockerfile, create a new file in your project directory and name it `Dockerfile`.

2. **Specify the base image**: The first step in creating a Dockerfile is to specify the base image that will be used as the starting point for our image. We can use any base image available on Docker Hub or create our own. For example, to use the official Ubuntu base image, add the following line to your Dockerfile:

   ```
   FROM ubuntu
   ```

3. **Install dependencies**: The next step is to install any necessary dependencies required for your application to run. For example, to install the Python 3 interpreter and its dependencies, add the following line to your Dockerfile:

   ```
   RUN apt-get update && \
       apt-get install -y python3
   ```

4. **Copy your application files**: Once you have installed any dependencies, you'll need to copy your application files into the Docker image. To do this, use the `COPY` instruction. For example, to copy a file named `app.py` into the root directory of the Docker image, add the following line to your Dockerfile:

   ```
   COPY app.py /
   ```

5. **Expose ports**: If your application listens on a particular port, you'll need to expose that port so that it can be accessed from outside the Docker container. To do this, use the `EXPOSE` instruction. For example, to expose port 5000, add the following line to your Dockerfile:

   ```
   EXPOSE 5000
   ```

6. **Define the startup command**: Finally, you'll need to define the command that should be run when the container starts. To do this, use the `CMD` instruction. For example, to run the Python script `app.py` when the container starts, add the following line to your Dockerfile:

   ```
   CMD ["python3", "app.py"]
   ```

## Build the Docker image

Once you have created your Dockerfile, you can build your Docker image using the `docker build` command. Navigate to the directory containing your Dockerfile and run the following command:

```
docker build -t my-image .
```

This command will build a Docker image with the tag `my-image` using the Dockerfile in the current directory (`.`).

## Conclusion

In this guide, we have walked through the process of creating a Docker image. By following these steps, you can create a Docker image that includes your application and all its dependencies, making it easy to deploy and run your application in any environment that supports Docker.