# Design

Hyperform 不使用任何容器编排平台。

Hyperform 的核心是单容器vm。为每一个容器创建一个单独的vm（instance），反过来说，一个vm（instance）只容纳一个容器。

hyperform 使用一个定制的 image 来创建单容器 vm。该 image 基于 Alpine Linux，因为它运行起来后自身占用资源极少。image 中预装了最新版 Docker CE。


