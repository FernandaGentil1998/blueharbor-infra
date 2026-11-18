# Lab 07 — Exercise 7.2: Configure Web Tier with an Ansible Playbook

## 1. Objective

Configure a web tier using an Ansible playbook. The exercise demonstrates declarative configuration management, Jinja2 templates, handlers, service management, HTTP validation, and idempotency.

## 2. Environment

| Component | Configuration |
|---|---|
| Control node | WEB01 |
| Managed node | WEB02 |
| Operating system | Ubuntu Server 24.04 LTS |
| Web server | Nginx |
| Ansible user | `opsadmin` |
| Inventory group | `web` |

Both hosts were confirmed reachable through Ansible before executing the playbook.

## 3. Project Structure

The following files and directories were created under `~/ansible`:

```text
ansible/
├── ansible.cfg
├── inventory.ini
├── web-tier.yml
└── templates/
    └── index.html.j2
```

## 4. Playbook Configuration

The `web-tier.yml` playbook was created:

```yaml
---
- name: Configure web tier
  hosts: web
  become: true

  tasks:
    - name: Install Nginx
      ansible.builtin.apt:
        name: nginx
        state: present
        update_cache: true

    - name: Deploy custom index page
      ansible.builtin.template:
        src: index.html.j2
        dest: /var/www/html/index.html
        owner: www-data
        group: www-data
        mode: '0644'
      notify: Restart Nginx

    - name: Ensure Nginx is enabled and running
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true

  handlers:
    - name: Restart Nginx
      ansible.builtin.service:
        name: nginx
        state: restarted
```

The playbook applies the desired configuration to all hosts in the `web` inventory group.

### Main Ansible components

- `hosts`: defines the target hosts.
- `become: true`: enables privilege escalation.
- `apt`: ensures Nginx is installed.
- `template`: deploys the Jinja2 template.
- `service`: ensures Nginx is running and enabled at boot.
- `notify`: triggers a handler when the template changes.
- `handlers`: executes the Nginx restart only when notified.

## 5. Jinja2 Template

The file `templates/index.html.j2` was created:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>BlueHarbor Web Tier</title>
</head>
<body>
    <h1>Welcome to BlueHarbor</h1>
    <p>Server: {{ inventory_hostname }}</p>
    <p>Managed by Ansible</p>
</body>
</html>
```

The `inventory_hostname` variable dynamically identifies each managed host.

Expected output:

- WEB01 displays `Server: web01`.
- WEB02 displays `Server: web02`.

Both servers use the same template while displaying their own hostname.

## 6. Syntax Validation

Before execution, the playbook syntax was checked:

```bash
ansible-playbook web-tier.yml --syntax-check
```

**Result:** Syntax validation passed successfully.

## 7. Playbook Execution

The playbook was executed from WEB01:

```bash
ansible-playbook web-tier.yml -K
```

The `-K` option prompts for the privilege escalation password.

### First execution results

| Task | WEB01 | WEB02 |
|---|---|---|
| Gathering Facts | OK | OK |
| Install Nginx | OK | OK |
| Deploy custom index page | Changed | Changed |
| Ensure Nginx is enabled and running | OK | OK |
| Restart Nginx handler | Changed | Changed |

Play recap:

```text
web01 : ok=5 changed=2 unreachable=0 failed=0
web02 : ok=5 changed=2 unreachable=0 failed=0
```

The HTML template was deployed on both hosts, triggering the Nginx restart handler.

## 8. HTTP Health Validation

The Ansible URI module was used to verify the local HTTP response on both servers:

```bash
ansible web -m uri -a "url=http://127.0.0.1 return_content=true"
```

**Results:**

| Validation | WEB01 | WEB02 |
|---|---|---|
| HTTP status | 200 | 200 |
| Web server | Nginx 1.24.0 | Nginx 1.24.0 |
| HTML response | Successful | Successful |
| Server identifier | `web01` | `web02` |

Both servers returned HTTP `200 OK` and the expected HTML content.

## 9. Idempotency Validation

The same playbook was executed a second time:

```bash
ansible-playbook web-tier.yml -K
```

### Second execution results

```text
web01 : ok=4 changed=0 unreachable=0 failed=0
web02 : ok=4 changed=0 unreachable=0 failed=0
```

No configuration changes were required, and the restart handler was not triggered.

This confirms that the playbook is idempotent: once the desired state is achieved, subsequent executions do not introduce unnecessary changes.

## 10. Key Learnings

- Ansible playbooks define repeatable infrastructure configuration.
- YAML is used to describe tasks and their execution order.
- Jinja2 templates allow dynamic configuration using Ansible variables.
- Handlers execute only when notified by a task.
- The `service` module manages service state and boot-time configuration.
- The `uri` module can validate HTTP responses.
- Idempotency prevents unnecessary configuration changes and service restarts.

## 11. Conclusion

Exercise 7.2 was successfully completed.

Nginx was installed and configured on WEB01 and WEB02 using an Ansible playbook. A shared Jinja2 template generated host-specific web pages, and handlers restarted Nginx only when required.

Both servers returned HTTP 200, and the second playbook execution reported `changed=0` on both hosts, confirming successful idempotency validation.
