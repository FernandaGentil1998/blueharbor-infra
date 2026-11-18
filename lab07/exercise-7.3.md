# Exercise 7.3 — Rolling Updates and Health Checks

## Objective

Orchestrate rolling updates across multiple web servers using Ansible, ensuring service availability through sequential deployment and HTTP health checks.

## Environment

| Component | Configuration |
|---|---|
| Control node | WEB01 |
| Managed nodes | WEB01 and WEB02 |
| Operating system | Ubuntu Server 24.04 |
| Web server | Nginx 1.24.0 |
| Application version | 1.1.0 |

## Rolling Update Playbook

Created `~/ansible/rolling-update.yml` with the following configuration:

- `serial: 1` — updates one server at a time.
- `max_fail_percentage: 0` — stops the rollout if a failure occurs.
- `ansible.builtin.template` — deploys the updated HTML page.
- `ansible.builtin.service` — ensures Nginx is enabled and running.
- `ansible.builtin.uri` — performs an HTTP health check.
- `delegate_to: localhost` — executes the health check from the control node.
- `failed_when` — validates HTTP status 200 and application version 1.1.0.
- Handler — restarts Nginx when the template changes.

## Execution and Validation

The playbook syntax check completed successfully.

The rolling update was executed sequentially:

1. WEB01 was updated and passed its HTTP health check.
2. WEB02 was updated only after WEB01 completed successfully and also passed its health check.

A subsequent HTTP validation confirmed the following results:

| Validation | WEB01 | WEB02 |
|---|---|---|
| HTTP status | 200 | 200 |
| Nginx version | 1.24.0 | 1.24.0 |
| Application version | 1.1.0 | 1.1.0 |
| HTML response | Valid, no duplication | Valid, no duplication |
| Health check | Passed | Passed |

Final Ansible recap for the successful rollout:

| Host | OK | Changed | Failed | Unreachable |
|---|---:|---:|---:|---:|
| WEB01 | 5 | 2 | 0 | 0 |
| WEB02 | 5 | 2 | 0 | 0 |

## Key Learnings

- Rolling updates reduce deployment risk by updating servers sequentially.
- `serial: 1` controls the number of hosts updated in each batch.
- `max_fail_percentage: 0` prevents the rollout from continuing after a failure.
- Handlers execute only when notified by a task reporting a change.
- HTTP health checks verify application availability and the deployed version.
- Ansible templates support dynamic configuration through Jinja2 variables such as `{{ inventory_hostname }}`.

## Result

**Exercise 7.3 completed successfully.** Both web servers are running Nginx and serving application version 1.1.0 with successful HTTP health checks.
