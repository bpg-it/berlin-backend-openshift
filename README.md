# springboot-demo-openshift

Scripts to setup dev/int/prod stages automatically using oc cli.

## Stage Namespace

### Modify script

Adjust

* STAGE_NAME
* SPRING_PROFILES_ACTIVE
* IMAGE_TAG

in file create-stage.sh.

### Run script

```bash
./create-stage.sh
```

### Change password

```bash
cd postgres
oc project bpgit-berlin-dev
oc process -o yaml -f postgres-secrets.yml | oc apply -f -
```

The postgresql pod needs to be restarted (killed) to apply changes.
