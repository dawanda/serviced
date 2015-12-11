# ServiceD

## Goals and Mission

We want a central access point for

* Service Management
* Service Dependency Management
* Service Discovery
* Service Monitoring
* Incident Management

### Service Management

Many services come and go. This is a central place to declare a service
with all its meta information and how to handle it.

We can deploy, monitor, and revert your service in the cloud.

### Service Dependency Management

Most service depend on other services. The more services get deployed, the
more complex the application stack as a whole becomes.

When declaring a new service all dependencies must be referenced, too.

This way we can provide you automatically with service dependency graphs
you can walk though and easily identify architectual bottlenecks
and it can aid in incident management to identify dependant services
that are affected by other services downtime.

### Service Discovery

With many services and even more hardware resources we need a way to
generically tell the application what service to find via which endpoint.

### Service Monitoring

A service or feature should go into production when its monitoring
is set in place. So we couple them tightly together.
When you declare a service with its dependencies, you also declare
health checks and responsibilities (contacts).

A service can only be deployed when it is fully declared, including health
checks.

Contacts help you to get notified via SMS as soon as a service fails.
Escalation contacts are notified when the service is not marked as
behind repaired within a per-service customizable time frame.

### Incident Management

Automatically pre-fill and issue incident reports with downtime durations,
affected services and customer facing features.
