Secrets
-------

http://kubernetes.io/docs/user-guide/secrets/

The kubectl create secret command packages these files into a Secret and creates the object on the Apiserver.

`$ kubectl create secret generic db-user-pass --from-file=./username.txt --from-file=./password.txt`

secret "db-user-pass" created

You can check that the secret was created like this:
`$ kubectl get secrets`
