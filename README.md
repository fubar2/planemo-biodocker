# planemo-biodocker

## Biodocker style container with planemo for testing tools found at https://quay.io/repository/fubar2/planemo-biocontainer

# Warnings

1. It's big because it has everything Planemo needs to spin up
a test Galaxy instance. It runs a test during the build to ensure that
the caches are all filled.

2. In developing it, I learned how easy it is to get root inside a biodocker
container using the standard python docker SDK. The ToolFactory https://github.com/fubar2/toolfactory and
related docker container https://github.com/fubar2/toolfactory-galaxy-docker uses this biodocker
to test new tools, and is able to give the biodocker user permissions on a mounted volume to make it easier to
share data.

