# HaElixir

An example of how to deploy multiple instances of a single elixir release while setting an environment variable differently for each instance. This is useful in the case of breaking up a monolithic applications into stateless and stateful parts that can be ran independently.

This example is intended to be used with minikube and helm.
## Initialization
Run `make init` to setup the helm repository and start minikube. This also tells docker to reuse the minikube docker daemon. To go back to a state where that is not the case, run `make unset-docker`.

## Build
Run `make build` to build the docker image to be used in minikube 

## Deploy
Run `make deploy` to deploy into minikube. This will deploy postgres, run database migrations and then start up 4 deployments, each with a different `SERVICE` environment variable set. This environment variable is then displayed in the greeting message at the root path of each deployment.

## Delete
Run `make delete` to delete all deployed infrastructure. This includes postgres and the persistent volume it uses.

## Migrate
Run `make migrate` to run the database migration job

## Accessing Services
Run `make port-forward` to forward the ports for all services. The services can then be accessed at the following locations:
- localhost:4000 -> Default service
- localhost:4001 -> Service #1
- localhost:4002 -> Service #2
- localhost:4003 -> Service #3

To cleanup the forwarded ports, run `make kill-port-forward`. Please note that this will kill all port forwarding, not just those established by `make port-forward`.

## Key code snippets
There are three files involved with setting the environment variables differently for each deployment.

A case is added to `server` that accepts an argument for which "service" to start. It then sets the `SERVICE` environment variable before starting the application.
```bash
case "$1" in
    "service-1")
        PHX_SERVER=true SERVICE=service-1 exec ./ha_elixir start
        ;;

    "service-2")
        PHX_SERVER=true SERVICE=service-2 exec ./ha_elixir start
        ;;

    "service-3")
        PHX_SERVER=true SERVICE=service-3 exec ./ha_elixir start
        ;;

    *)
        PHX_SERVER=true SERVICE=default exec ./ha_elixir start
        ;;
esac
```

Inside the application, we simply read from the environment variable and pass it on the the view to be rendered.
```elixir
def index(conn, _params) do
    render(conn, "index.html", service: System.get_env("SERVICE", "Default"))
end
```

Finally, we tell kubernetes in `k8s/deployments.yaml` to override the default command and arguments in order to start the service of our choice.
```yaml
spec:
    containers:
       - image: ha_elixir
         name: service-1 
         command: ["/app/bin/server"]
         args: ["service-1"]

```
