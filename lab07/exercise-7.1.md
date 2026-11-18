# Lab 07 — Exercise 7.1: Set Up Ansible and Run Ad-hoc Commands

## 1. Objective

Set up Ansible on WEB01 as the control node, configure an inventory of managed hosts, establish SSH connectivity, and execute ad-hoc commands to validate remote management.

## 2. Environment

| Component | Configuration |
|---|---|
| Control node | WEB01 |
| Managed node | WEB02 |
| Operating system | Ubuntu Server 24.04 LTS |
| Ansible user | `opsadmin` |
| WEB01 IP | `10.10.20.20` |
| WEB02 IP | `10.10.20.21` |
| SSH authentication | ED25519 key-based authentication |

## 3. Ansible Installation

Ansible was installed on WEB01:

```bash
sudo apt update
sudo apt -y install ansible
```

The project directory was created:

```bash
mkdir -p ~/ansible
cd ~/ansible
```

## 4. SSH Key Authentication

An ED25519 SSH key pair was generated on WEB01:

```bash
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519
```

The public key was copied to WEB02:

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub opsadmin@10.10.20.21
```

SSH connectivity was verified successfully:

```bash
ssh opsadmin@10.10.20.21
```

WEB01 could connect to WEB02 without entering the account password.

## 5. Inventory Configuration

The `inventory.ini` file was created:

```ini
[web]
web01 ansible_host=10.10.20.20 ansible_connection=local
web02 ansible_host=10.10.20.21

[storage]
# stor01 ansible_host=10.10.20.30

[all:vars]
ansible_user=opsadmin
ansible_python_interpreter=/usr/bin/python3
```

Ansible configuration was defined in `ansible.cfg`:

```ini
[defaults]
inventory = inventory.ini
forks = 10
```

WEB01 uses a local connection, while WEB02 is managed remotely over SSH.

## 6. Connectivity Test

The Ansible ping module was executed:

```bash
ansible all -m ping
```

**Result:** Both hosts returned `SUCCESS` with `pong`.

- WEB01: `SUCCESS`
- WEB02: `SUCCESS`

## 7. Remote Command Execution

The following ad-hoc command was used to retrieve system uptime:

```bash
ansible all -a "uptime"
```

**Result:** Both hosts successfully returned their uptime and load average information.

The command module reported `CHANGED`. This is expected because Ansible cannot automatically determine whether an arbitrary command changes the system state.

## 8. System Facts Collection

Ubuntu distribution information was collected using the setup module:

```bash
ansible all -m setup -a "filter=ansible_distribution*"
```

**Result:** Both hosts were identified as:

- Distribution: Ubuntu
- Distribution version: 24.04
- Distribution release: Noble

The task returned `changed: false`, as gathering facts does not modify the managed hosts.

## 9. Privilege Escalation and Package Management

Ansible was used to install the `tree` package on both hosts:

```bash
ansible web -b -K -m apt -a "name=tree state=present"
```

Options used:

- `-b`: enables privilege escalation (become).
- `-K`: prompts for the become password.
- `-m apt`: uses the APT module.
- `name=tree`: specifies the package.
- `state=present`: ensures the package is installed.

### Initial issue on WEB02

The first execution failed on WEB02 because `dpkg` had an interrupted package configuration:

```text
dpkg was interrupted, you must manually run
'sudo dpkg --configure -a' to correct the problem.
```

The issue was resolved directly on WEB02:

```bash
sudo dpkg --configure -a
```

The Ansible installation command was then executed again.

### Final result

| Host | Ansible result | State |
|---|---|---|
| WEB01 | `SUCCESS`, `changed: false` | Package already installed |
| WEB02 | `SUCCESS`, `changed: true` | Package installed successfully |

During the WEB02 operation, the pending Suricata package configuration was also completed.

## 10. Key Learnings

- Ansible can manage remote Linux hosts over SSH.
- Inventory files define managed hosts and connection variables.
- Ad-hoc commands are useful for quick administration and troubleshooting.
- The `setup` module collects system facts.
- Privilege escalation is performed with `become`.
- The APT module manages packages declaratively.
- Idempotency ensures that an already satisfied state is not unnecessarily changed.

## 11. Conclusion

Exercise 7.1 was successfully completed. Ansible was installed and configured on WEB01, SSH connectivity to WEB02 was established, and ad-hoc commands were executed successfully on both hosts.

Both managed hosts responded to Ansible, returned system information, and reached the desired package state through the APT module.
