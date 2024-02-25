# # Use an official Node runtime as the base image
# FROM node:18-alpine AS build

# # Set the working directory in the container
# WORKDIR /app

# # Copy package.json and package-lock.json to the working directory
# COPY package*.json ./

# # Install dependencies
# RUN npm install

# # Copy the entire project to the working directory
# COPY . .

# # Build the React app
# RUN npm run build

# # Stage 2: Serve the React app with a lightweight Node server
# FROM node:18-alpine

# # Set the working directory in the container
# WORKDIR /app

# # Copy the build files from the previous stage
# COPY --from=build /app/build ./build

# # Install serve to run the application
# RUN npm install -g serve

# # Expose the port the app runs on
# EXPOSE 3000

# # Serve the app
# CMD ["serve", "-s", "build"]


# Stage 1: Build React Application
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Build the React app
RUN npm run build

# Stage 2: Serve React App with Nginx
FROM nginx:alpine

# Copy the build files from Stage 1
COPY --from=build /app/build /usr/share/nginx/html

# Copy Nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
