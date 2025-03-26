## Minio Side 
1- Brig up a minio and Creat bucket named velero-backups
```

version: '3'
services:
  minio:
    image: quay.io/minio/minio
    container_name: minio
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: admin
      MINIO_ROOT_PASSWORD: password
    ports:
      - "9000:9000"  # S3 API
      - "9001:9001"  # Web UI
    volumes:
      - minio-data:/data
volumes:
  minio-data:
```
## Install Velero 
1- Create minio Buket Credential 
```
cat <<EOF > credentials-velero
[default]
aws_access_key_id=admin
aws_secret_access_key=password
EOF
```
2- Install velero  
```
wget https://github.com/vmware-tanzu/velero/releases/download/v1.15.2/velero-v1.15.2-linux-amd64.tar.gz && tar xvf  velero-v1.15.2-linux-amd64.tar.gz && cd velero-v1.15.2-linux-amd64 && cp velero  /usr/local/bin/
```
it will bring up veleor pod 
```
velero install \
    --provider aws \
    --plugins velero/velero-plugin-for-aws:v1.8.1 \
    --bucket velero-backups \
    --secret-file ./credentials-velero \
    --backup-location-config region=minio,s3Url=http://192.168.7.253:9000,s3ForcePathStyle="true" \
    --use-volume-snapshots=false 

```

3- Take a backup
```
velero backup create BACKUP_NAME --include-namespaces '*' --wait

![image](https://github.com/user-attachments/assets/5915e7ea-f527-4e3c-a9aa-de8091eeebdf)

```
3-1 You can restore backup with 
```
velero get backup 
velero restore create --from-backup BACKUP_NAME
```
![image](https://github.com/user-attachments/assets/ec243d9a-51db-4376-9870-8bf8d34af7bb)

3-2 Schedule You backup
This Velero backup schedule runs daily at 07:00 UTC. The schedule follows the cron format, where:
```
velero schedule create backup --schedule "0 7 * * *"
```



