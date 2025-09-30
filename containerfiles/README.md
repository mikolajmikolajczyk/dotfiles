# Containerfiles README

This directory contains Containerfiles and related resources for building development containers. These images are intended to be used with [distrobox](https://distrobox.it/), providing flexible and powerful development environments.

## Why are the images so big?

- **Comprehensive Tooling:** Each image comes pre-installed with compilers, interpreters, editors, and debugging tools for multiple languages.
- **Convenience:** The aim is to minimize setup time by offering a ready-to-use environment for developers.
- **Broad Compatibility:** Supporting a wide range of projects requires including many libraries and utilities, which increases image size.
- **Reduced Build Times:** By including dependencies in the image, container startup and project setup are faster, trading off image size for developer productivity.

## Usage

Run the images with distrobox as needed for your development tasks. Refer to individual Containerfiles for specific tools and configurations included.
