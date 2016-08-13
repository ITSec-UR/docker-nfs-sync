#!/bin/bash
set -e

if [ -z "$NFS_SERVER" ]; then
  echo "NFS_SERVER not set."
  exit 1
fi

if [ -z "$REMOTE_SHARE" ]; then
  echo "REMOTE_SHARE not set."
  exit 1
fi

if [ -z "$SYNC_DIR" ]; then
  echo "SYNC_DIR not set."
  exit 1
fi

: ${LOCAL_MOUNTDIR=/tmp/remote-mount}

echo "Mounting remote directory $NFS_SERVER:$REMOTE_SHARE..."
mkdir -p $LOCAL_MOUNTDIR
umount $LOCAL_MOUNTDIR || /bin/true
mount -t nfs $NFS_SERVER:$REMOTE_SHARE $LOCAL_MOUNTDIR

echo "Syncing files from $NFS_SERVER:$REMOTE_SHARE to $SYNC_DIR..."
mkdir -p $SYNC_DIR
rsync -tr $LOCAL_MOUNTDIR/* $SYNC_DIR/

echo "Done!"