# TK8 addon - Velero (minio)

## What are TK8 addons?

- TK8 add-ons provide freedom of choice for the user to deploy tools and applications without being tied to any customized formats of deployment.
- Simplified deployment process via CLI (will also be available via TK8 web in future).
- With the TK8 add-ons platform, you can also build your own add-ons.

To get more support join us on [Slack](https://kubernauts-slack-join.herokuapp.com)

## What is Velero?

Velero (formerly Heptio Ark) gives you tools to back up and restore your Kubernetes cluster resources and persistent volumes. Velero lets you:
- Take backups of your cluster and restore in case of loss.
- Copy cluster resources to other clusters.
- Replicate your production environment for development and testing environments.

## Get started

You need
- A kubernetes cluster.
- A default storage class defined. Velero doesn't support hostPath volumes for backup and restore
- TK8 binary

## Deploy velero-minio on the Kubernetes Cluster

Run **tk8 addon install velero-minio**

    $ tk8 addon install velero-minio
    Install velero-minio velero-minio
    execute main.sh
    apply main.yml
    customresourcedefinition.apiextensions.k8s.io/backups.velero.io created
    customresourcedefinition.apiextensions.k8s.io/schedules.velero.io created
    customresourcedefinition.apiextensions.k8s.io/restores.velero.io created
    customresourcedefinition.apiextensions.k8s.io/downloadrequests.velero.io created
    customresourcedefinition.apiextensions.k8s.io/deletebackuprequests.velero.io created
    customresourcedefinition.apiextensions.k8s.io/podvolumebackups.velero.io created
    customresourcedefinition.apiextensions.k8s.io/podvolumerestores.velero.io created
    customresourcedefinition.apiextensions.k8s.io/resticrepositories.velero.io created
    customresourcedefinition.apiextensions.k8s.io/backupstoragelocations.velero.io created
    customresourcedefinition.apiextensions.k8s.io/volumesnapshotlocations.velero.io created
    customresourcedefinition.apiextensions.k8s.io/serverstatusrequests.velero.io created
    namespace/velero created
    serviceaccount/velero created
    clusterrolebinding.rbac.authorization.k8s.io/velero created
    deployment.apps/minio created
    service/minio created
    secret/cloud-credentials created
    job.batch/minio-setup created
    backupstoragelocation.velero.io/default created
    deployment.apps/velero created
    daemonset.apps/restic created
    velero-minio installation complete

This command will clone the kubernauts' velero-minio repository (https://github.com/kubernauts/tk8-addon-velero-minio) locally and install the necessary components.

This command creates:
- Velero namespace
- Secrets , ServiceAccount and Roles and RoleBindings for velero
- Custom Resource Definitions for Velero
- Velero and Restic Deployment for Taking backup and restore
- Minio Object store deployment for storing backups

If all goes, you should see all resources in Running state:

    $ Kubectl get all --namespace velero
    NAME                          READY   STATUS      RESTARTS   AGE
    pod/minio-d9c56ff5-6q4zf      1/1     Running     0          3m32s
    pod/minio-setup-5qftv         0/1     Completed   0          3m32s
    pod/restic-5wz2z              1/1     Running     0          3m32s
    pod/restic-tjrj7              1/1     Running     0          3m32s
    pod/velero-69d49978f5-q5psk   1/1     Running     2          3m32s
     
    NAME            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
    service/minio   ClusterIP   10.104.169.75   <none>        9000/TCP   3m32s
     
    NAME                    DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
    daemonset.apps/restic   2         2         2       2            2           <none>          3m32s
    
    NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/minio    1/1     1            1           3m32s
    deployment.apps/velero   1/1     1            1           3m32s
     
    NAME                                DESIRED   CURRENT   READY   AGE
    replicaset.apps/minio-d9c56ff5      1         1         1       3m32s
    replicaset.apps/velero-69d49978f5   1         1         1       3m32s
     
    NAME                    COMPLETIONS   DURATION   AGE
    job.batch/minio-setup   1/1           33s        3m32s

## Uninstalling Velero minio

For removing velero-minio from your cluster, we can use TK8 addon's destroy functionality. Run **tk8 addon destroy velero-minio**

    $ tk8 addon destroy velero-minio
    Destroying velero-minio
    execute main.sh
    delete velero-minio from cluster
    customresourcedefinition.apiextensions.k8s.io "backups.velero.io" deleted
    customresourcedefinition.apiextensions.k8s.io "schedules.velero.io" deleted
    customresourcedefinition.apiextensions.k8s.io "restores.velero.io" deleted
    customresourcedefinition.apiextensions.k8s.io "downloadrequests.velero.io" deleted
    customresourcedefinition.apiextensions.k8s.io "deletebackuprequests.velero.io" deleted
    customresourcedefinition.apiextensions.k8s.io "podvolumebackups.velero.io" deleted
    customresourcedefinition.apiextensions.k8s.io "podvolumerestores.velero.io" deleted
    customresourcedefinition.apiextensions.k8s.io "resticrepositories.velero.io" deleted
    customresourcedefinition.apiextensions.k8s.io "backupstoragelocations.velero.io" deleted
    customresourcedefinition.apiextensions.k8s.io "volumesnapshotlocations.velero.io" deleted
    customresourcedefinition.apiextensions.k8s.io "serverstatusrequests.velero.io" deleted
    namespace "velero" deleted
    serviceaccount "velero" deleted
    clusterrolebinding.rbac.authorization.k8s.io "velero" deleted
    deployment.apps "minio" deleted
    service "minio" deleted
    secret "cloud-credentials" deleted
    job.batch "minio-setup" deleted
    deployment.apps "velero" deleted
    daemonset.apps "restic" deleted
    velero-minio destroy complete

## Authors

* **Billie Thompson** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/kubernauts/tk8/contributors) who participated in this project.

## License

This project is licensed under the Apache License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc
