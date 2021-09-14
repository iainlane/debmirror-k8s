# Debmirror for Kubernetes

I wanted to move this off a systemd timer running on my desktop computer. So
here's a collection of stuff to let you run a Debian mirror locally. It's pretty
specific to my setup but maybe it's useful to someone or you want to contribute
to generalise it a bit.

The Dockerfile here builds an image with `debmirror`, `gpg` and the keyrings set
up. They're uploaded to Docker Hub
([debian](https://hub.docker.com/repository/docker/iainlane/debmirror-debian)
[ubuntu](https://hub.docker.com/repository/docker/iainlane/debmirror-ubuntu)) by
an action here.

In `k8s` and `kustomization.yaml` you've got the setup I'm using which assumes
the following-

  * nginx-ingress
  * cert-manager with a `ClusterIssuer` called `letsencrypt-production-issuer`
  * A `StorageClass` called `local-packages` (I'm using
    `local-static-provisioner`, see below)

All of that said, then a `CronJob` is set up to run `debmirror` hourly, and an
`nginx` instance is also provisioned to serve it over the web.

## Caveats

  * The storage is handled a bit weirdly. If you delete the
    `PersistentVolumeClaim` then the `local-static-provisioner` will scrub the
    volume and delete your mirror. Obviously it takes a long time to initially
    provision so this is a bit undesirable. Make sure you don't delete that
    unless you want to have to re-mirror.
  * I wanted to use `ENDPOINT` in the Dockerfile to have just the argument
    supplied via `ARGS`, but I couldn't get it to work properly. So it's a bit
    annoying to change the arguments.

## TODO

  * Unhardcode the hostname (move to Helm?)
  * Unhardcode the cert-manager / load-balancer stuff
  * Unhardcode the namespace
  * Handle the storage a bit better
