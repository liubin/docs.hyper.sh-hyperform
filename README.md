# Hyperform


## What is Hyperform?

Hyperform is a cloud automation tool that immediately transforms any VM cloud infrastructure into a container infrastructure. It allows companies to provision, deploy, and orchestrate containerized application on any cloud with a serverless workflow. 

Hyperform aims to support public clouds, including Amazon AWS, Azure, Google Cloud, as well as private clouds, including VMWare vSphere, Nutanix, and OpenStack. For now only AWS is supported, but more clouds will be add in.


## Design

Hyperform 不使用任何容器编排平台。

Hyperform 的核心是单容器vm。为每一个容器创建一个单独的vm（instance），反过来说，一个vm（instance）只容纳一个容器。

hyperform 使用一个定制的 image 来创建单容器 vm。该 image 基于 Alpine Linux，因为它运行起来后自身占用资源极少。image 中预装了最新版 Docker CE。

(TO DO)
