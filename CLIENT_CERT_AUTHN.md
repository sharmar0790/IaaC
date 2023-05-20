## Client Certificate Authentication
CA Authentication also known as Mutual Authentication allows both the server and client to verify each others identity via a common CA.

We have a CA Certificate which we usually obtain from a Certificate Authority and use that to sign both our server certificate and client certificate. 
Then every time we want to access our backend, we must pass the client certificate.

These instructions are based on the following [blog](https://awkwardferny.medium.com/configuring-certificate-based-mutual-authentication-with-kubernetes-ingress-nginx-20e7e38fdfca)

#### Generate the CA Key and Certificate:
```
openssl req -x509 -sha256 -newkey rsa:4096 -keyout ca.key -out ca.crt -days 356 -nodes -subj '/CN=My Cert Authority'
```
Generate the Server Key, and Certificate and Sign with the CA Certificate:
```
openssl req -new -newkey rsa:4096 -keyout server.key -out server.csr -nodes -subj '/CN=mydomain.com'
openssl x509 -req -sha256 -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt
```

Generate the Client Key, and Certificate and Sign with the CA Certificate:
```
openssl req -new -newkey rsa:4096 -keyout client.key -out client.csr -nodes -subj '/CN=My Client'
openssl x509 -req -sha256 -days 365 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 02 -out client.crt
```

Once this is complete you can continue to follow the instructions here
