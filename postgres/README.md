# Change PostgreSQL Passwords

Use the following commands to change PostgreSQL passwords on OpenShift. All passwords base Bas64 encoded: [https://www.base64encode.org/](https://www.base64encode.org/)

```bash
oc process -o yaml -f postgres-secrets.yml | oc apply -f -
```
