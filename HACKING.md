
# TODO

- account management
  - authenticate via OAuth (Github or Google)
  - RBAC - role based access control
- support different environments (production, jail, staging)
- service management
  - deploy different enviornments
  - view current clusters & environments
  - scale up / scale down
  - automatic and implicit health monitoring
- service health monitoring
  - provide defaults for different kinds of services
  - have a nice Ruby DSL for defining your health check (Luca-O?)
  - have a dedicated daemon running these health checks
    - notifies owners and escalation contacts
- visibility:
  - automatically create graph images to visualize the application architecture
- dashboards
  - custom dashboard available to all members
  - personalised dashboards

## Make Me Company independant

- pass endpoints upon docker container startup
- configuration:
  - github organization the users must be part of in order to get in
  - mesos/marathon cluster endpoint (IP:PORT)

## Names

- `serviced` web application
- `servicectl` CLI tool for automation and your favorite shell

## Models

```
HealthCheckTemplate {
  string name;            # e.g. "tcp-connect", "smtp", "http", "redis", or ...
  text code;              # ruby code block to execute
  int interval;           # run check every N secs
  int timeout;            # treat check as failed if it runs longer then N secs
}

HealthCheck {
  Service service;
  text code;              # ruby code block to execute
  int interval;           # run check every N secs
  int timeout;            # treat check as failed if it runs longer then N secs
}

Service {
  string name;
  string display_name;
  string docker_image;    # such as example/myapp
  string github_url;      # Github project URL
  Service[] dependencies; # hard dependencies
  Service[] uses;         # soft dependencies (system still up when failing
                          # but degraded)
  Feature[] implements;   # list of features this service [partially] implements
}

# an abstract entity to give a highlevel overview of what is failing due to
# a downtime
Feature {
  string display_name;    # e.g. "Cart Checkout", or "Product Show Page"
  Service[] dependencies; # list of services used to implement this feature
}

Environment {
  string name;            # such as production, jail1, staging1, staging2, ...
  string display_name;
  Instance[] instances;   # list of service instances currently running
}

Instance {
  User author;
  Environment env;
  Service service;
  string docker_tag;
  string release_message;
  int instance_count;
  InstanceLocation[] locations;
}

# and if mesos/marathon can provide us the info on which HW node it spawned
# our services, we can list them, too.
# (which we need for individual health checks)
InstanceLocation {
  string hostname;
  int port;
}
```
