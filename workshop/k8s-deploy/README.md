

## 1. Install Ansible
```
$pip install ansible
```

## 2. Run the playbook
```
$ansible-playbook -i inventory.ini k8s-ha-stacked-etcd.yml -v
```

Go to first node
```
$kubectl get node

NAME   STATUS   ROLES           AGE     VERSION
cp1    Ready    control-plane   30m     v1.34.1
cp2    Ready    control-plane   31s     v1.34.1
cp3    Ready    control-plane   3m16s   v1.34.1
w1     Ready    <none>          17m     v1.34.1
w2     Ready    <none>          17m     v1.34.1
```

## Delete all servers
```
$ansible-playbook -i inventory.ini delete.yml -v
```