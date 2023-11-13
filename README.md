# Debmirror for Kubernetes

I wanted to move this off a systemd timer running on my desktop computer. So
here's a collection of stuff to let you run a Debian mirror locally. It's pretty
specific to my setup but maybe it's useful to someone or you want to contribute
to generalise it a bit.

For Ubuntu, all supported releases will be mirrored for `amd64` and `arm64`. For
Debian, `oldstable` and newer will be mirrored for `amd64`, `arm64`, `all` and
`i386`.

The Dockerfile here builds an image with `debmirror`, `gpg` and the keyrings set
up. [It's uploaded to Docker
Hub](https://hub.docker.com/repository/docker/iainlane/debmirror) by an action
here.

In `k8s` and `kustomization.yaml` you've got the setup I'm using which assumes
the following-

  * nginx-ingress
  * cert-manager with a `ClusterIssuer` called `letsencrypt-production-issuer`
  * A `StorageClass` called `openebs-zfspv`. I'm using OpenEBS with ZFS local
    storage for this.

All of that said, then a `CronJob` is set up to run `debmirror` hourly from the
latest image which has been pushed from `main` here, and an `nginx` instance is
also provisioned to serve it over the web.

## Caveats

  * If you delete any of your PVCs then the mirror will be cleaned up. You can
  fix that by using a different `StorageClass` which doesn't do that, or by
  using a `PersistentVolume` with `persistentVolumeReclaimPolicy: Retain` and
  manually deleting the `PersistentVolume` when you want to clean the mirror.

## TODO

  * Unhardcode the hostname (move to Helm?)
  * Unhardcode the cert-manager / load-balancer stuff
  * Unhardcode the namespace
  * Handle the storage a bit better
