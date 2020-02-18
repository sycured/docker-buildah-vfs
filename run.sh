#!/bin/bash
set -x
mkimg=$(buildah from fedora:rawhide)
buildah config --author='sycured' $mkimg
buildah config --label Name='buildah-vfs' $mkimg
buildah run "$mkimg" -- dnf upgrade -y --nogpg
buildah run "$mkimg" -- dnf install buildah git podman skopeo -y --nogpg
mntimg=$(buildah mount $mkimg)
rm -rf $mntimg/var/cache/dnf/*
cp storage.conf $mntimg/etc/containers/storage.conf
buildah unmount $mkimg
buildah commit --squash "$mkimg" "buildah-vfs"
buildah rm "$mkimg"
