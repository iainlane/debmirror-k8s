# Debmirror for Kubernetes

I wanted to move this off a systemd timer running on my desktop computer. So
here's a collection of stuff to let you run a Debian mirror locally. It's pretty
specific to my setup but maybe it's useful to someone or you want to contribute
to generalise it a bit.

The Dockerfile here builds an image with `debmirror`, `gpg` and the keyrings set
up. [It's uploaded to Docker
Hub](https://hub.docker.com/repository/docker/iainlane/debmirror) by an action
here.

In `k8s` and `kustomization.yaml` you've got the setup I'm using which assumes
the following-

  * nginx-ingress
  * cert-manager with a `ClusterIssuer` called `letsencrypt-production-issuer`
  * A `StorageClass` called `local-packages` (I'm using
    `local-static-provisioner`, see below. I find this a bit easier than using
    `local`: it takes care of affinity implicitly - making sure the mirror
    lands on the node with the actual mirror attached to it.)

All of that said, then a `CronJob` is set up to run `debmirror` hourly, and an
`nginx` instance is also provisioned to serve it over the web.

## Caveats

  * The storage is handled a bit weirdly. If you delete the
    `PersistentVolumeClaim` then the `local-static-provisioner` will scrub the
    volume and delete your mirror. Obviously it takes a long time to initially
    provision so this is a bit undesirable. Make sure you don't delete that
    unless you want to have to re-mirror.
    * An alternative (what I've done locally) is to set the
      `blockCleanerCommand` in `local-static-provisioner`'s `ConfigMap` for
      this `StorageClass` to `/bin/true`. This means that if you have to
      recreate the `PersistentVolume` for any reason then it's simply not
      cleaned up. In general this is probably not what you want - you want PVs
      to be fresh each time - but here it's quite nice because you can move the
      mirror around. If you do this you'll want to use a separtate
      `StorageClass` just for the mirror.
  * I wanted to use `ENDPOINT` in the Dockerfile to have just the argument
    supplied via `ARGS`, but I couldn't get it to work properly. So it's a bit
    annoying to change the arguments.

## TODO

  * Unhardcode the hostname (move to Helm?)
  * Unhardcode the cert-manager / load-balancer stuff
  * Unhardcode the namespace
  * Handle the storage a bit better
