## Storyscript Chart

A Helm chart for the Storyscript platform

#### Setup

- Get [skaffold](https://skaffold.dev/docs/install/)
```bash
$ brew install skaffold
```
- Configure [`default-repo`](https://skaffold.dev/docs/environment/image-registries/) to avoid pushing images to the `storyscript` repository
```bash
$ echo "export SKAFFOLD_DEFAULT_REPO=my-repo" >> ~/.bashrc  # or your shell
```
- Clone the chart and all its build artifacts, under the same directory
```bash
$ git clone git@github.com:storyscript/storyscript-chart.git
$ yq read storyscript-chart/skaffold.yaml "build.artifacts.*.image" |
  while read artifact
  do
    git clone "git@github.com:$artifact.git"
  done
```

#### Run
- Get the helm values file for your pool env
```bash
$ helm get values storyscript > values.env.yaml
```

- Start skaffold
```bash
$ skaffold dev      # to build and deploy on every code change
$ skaffold run      # to build and deploy once
```
