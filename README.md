# Configuracion dinamica de Varnish basada en metadatos de Rancher

Esta imagen inicia varnish que lee los metadatos de rancher para autoconfigurar backends basados en la definicion de labels, de otros stacks o de su propio stack.

# Como funciona
* Crear su stack con varnish y las aplicaciones que desee utilizar.
* Agregar los labels a cada aplicacion que desee agregar como backend. Necesita definir dos labels:
  * io.rancher_varnish_backend: este label indicara que se debe agregar como backend y ademas indicara el nombre del backend dentro de la configuracion de varnish.
  * io.rancher_varnish_backend_port: puerto donde se encuentra escuchando la aplicación.
* Ademas se pueden definir diferentes opciones de configuracion para el archivo default.vcl definiendo metadatos en el archivo rancher-compose





# Ejemplo de uso
Contenedor que corre varnish y un backend, docker-compose.yml: 
```yml
varnish:
  image: gafonso21/varnish
  stdin_open: true
  labels:
    io.rancher.container.hostname_override: container_name
    io.rancher.container.pull_image: always
  ports:
    - 80:80
app:
  image: gafonso21/app
  sdin_open: true
  labels:
    io.rancher.container.hostname_override: container_name
    io.rancher.container.pull_image: always
    io.rancher_varnish_backend_port: 8022
    io.rancher_varnish_backend: "true"
```
Agregar otro backend:

```yml
app2:
  image: gafonso21/app
  stdin_open: true
  labels:
    io.rancher.container.hostname_override: container_name
    io.rancher.container.pull_image: always
    io.rancher_varnish_backend_port: 8080
    io.rancher_varnish_backend: "apptest"
```

rancher-compose.yml:
```yml 
varnish:
  scale: 1
  health_check:
    port: 80
    interval: 2000
    unhealthy_threshold: 3
    strategy: recreate
    response_timeout: 2000
    healthy_threshold: 2
  metadata:
    varnish-backends:
      options: |
       sub vcl_pass {
        # Called upon entering pass mode. In this mode, the request is passed on to the backend, and the
        # backend's response is passed on to the client, but is not entered into the cache. Subsequent
        # requests submitted over the same client connection are handled normally.
        #return (pass);
       }

       # The data on which the hashing will take place
       sub vcl_hash {
       # Called after vcl_recv to create a hash value for the request. This is used as a key
       #  to look up the object in Varnish.

         hash_data(req.url);

         if (req.http.host) {
           hash_data(req.http.host);
         } else {
           hash_data(server.ip);
         }

       # hash cookies for requests that have them
         if (req.http.Cookie) {
           hash_data(req.http.Cookie);
         }
       }
```
