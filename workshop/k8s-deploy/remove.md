

## 1. Check Cluster Health First
```
kubectl get nodes
kubectl get pods -n kube-system
# Check etcd health
kubectl exec -n kube-system etcd-<node-name> -- etcdctl \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  member list
```

## 2. Ensure You Have Quorum
```
Critical: For HA clusters, you need at least 3 control plane nodes. Never remove a node if it breaks quorum (majority)
```

* 3 nodes → can tolerate 1 failure (need 2 for quorum)
* 5 nodes → can tolerate 2 failures (need 3 for quorum)

## 3. Cordon the Node (Prevent new pods)
```
kubectl cordon <control-plane-node-name>
```

## 4. Drain the Node (Evict all pods safely)
```
kubectl drain <control-plane-node-name> \
  --ignore-daemonsets \
  --delete-emptydir-data \
  --force \
  --timeout=300s
```

## 5. Remove Node from Cluster
```
kubectl delete node <control-plane-node-name>
```

## 6. Remove etcd Member (On remaining control plane node)
```
# Get member ID
sudo etcdctl --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  member list

# Remove the member
sudo etcdctl --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  member remove <member-id>
```

## 7. Clean Up the Node Itself (SSH to the node being removed)
```
# Reset kubeadm completely
sudo kubeadm reset --force

# Clean up
sudo rm -rf /etc/kubernetes
sudo rm -rf /var/lib/etcd
sudo rm -rf /var/lib/kubelet
sudo rm -rf /etc/cni/net.d
```

## 8. Verify Cluster Health
```
kubectl get nodes
kubectl get pods -A
```

## 9. Back up etcd before removal if this is critical data
```
sudo etcdctl --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  snapshot save backup.db
```