# planemo-biodocker

## Biodocker style container with planemo for testing tools

# Warnings

1. It's big because it has everything Planemo needs to spin up
a test Galaxy instance. It runs a test during the build to ensure that
the caches are all filled.

2. In developing it, I learned how easy it is to get root inside a biodocker
container using the standard python docker SDK. The ToolFactory uses this biodocker and is able to give the
biodocker user permissions on a mounted volume to make it easier to
share data.

