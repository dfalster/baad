# Using the BAAD docker images

Docker is a program that allows users to makes virtual machines (called containers) that contain all the software needed to run a program or analysis. As such it is a tool that can be used to guarantee some software will always run the same way, regardless of the environment it is running in. Instructions on how to install this can be found [here](https://docs.docker.com).

Assuming you have docker installed and configured correctly, you can load images containing the BAAD source code and required R packages to rerun the analysis. We have three images:

- `dfalster/baad` includes the source code but without having built the outputs
- `dfalster/baad_all` includes `dfalster/clean` plus we have already run `remake::make("all")`
- `dfalster/baad_everything` includes `dfalster/clean` plus we have already run `remake::make("everything")`, so includes all the reports

To get the repos onto your local machine you download them from dockerhub, e.g. in terminal type

    docker pull dfalster/baad_clean
