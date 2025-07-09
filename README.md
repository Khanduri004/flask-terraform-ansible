# Flask-Terraform-Ansible-Jenkins-Docker Demo

## Overview

This project demonstrates deploying a Flask app on AWS EC2 using Terraform, configuring the instance with Ansible, containerizing the app with Docker, 
and automating the workflow using Jenkins.

## Steps

1. Push code to GitHub.
2. Jenkins pipeline:
   - Runs Terraform to create EC2 instance.
   - Runs Ansible to install Docker.
   - Deploys Flask app inside Docker container.
3. Access Flask app at `http://<EC2_PUBLIC_IP>:5000`

## Requirements

- AWS CLI configured
- Jenkins with SSH credentials and Terraform installed
- Docker Hub account (optional for pushing images)
