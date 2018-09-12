Bosh release for stopping Portworx in PKS

## What is this?

This is a simple bosh release to stop the Portworx systemd service on bosh worker nodes in a PKS environment.

## Why is this required?

This is required since when stopping and upgrade instances bosh attempts to unmount `/var/vcap/store`. Portworx has it's rootfs for the runc container mounted on `/var/vcap/store/opt/pwx/oci` and the runc container is running using it. So one needs to stop Portworx and unmount `/var/vcap/store/opt/pwx/oci` in order to allow bosh to proceed with stopping the instances.

## How to build

For dev releases,
```
bosh create-release --force
```

For final releases,
```
bosh create-release --final --version=<give-your-version-here>
```

Upload the created release to the bosh director.
```
bosh -e <your-director-env> upload-release
```

## How to use it

This release is intended to run as a [bosh director runtime config addon job](https://bosh.io/docs/runtime-config/#addons).

You can find a [sample runtime config here](runtime-configs/director-runtime-config.yaml)

To view your current director runtime config: `bosh -e my-env runtime-config`

To update a director runtime config: `bosh update-runtime-config runtime-configs/director-runtime.config.yaml`

## References

* [Create a release](https://bosh.io/docs/cli-v2/#release-creation)
* [Bosh CLI] (https://bosh.io/docs/cli-v2/)
* [Portworx documentation](https://docs.portworx.com/scheduler/kubernetes/)

