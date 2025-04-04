# Kubernetes Audit Logging Setup Guide

Kubernetes auditing provides a security-relevant, chronological set of records documenting the sequence of actions in a cluster. This guide outlines how to configure audit logging in a Kubernetes cluster.

## Table of Contents

- [Overview](#overview)
- [Audit Policy Configuration](#audit-policy-configuration)
- [Enabling Audit Logging](#enabling-audit-logging)
- [Audit Backends](#audit-backends)
- [Audit Annotations](#audit-annotations)
- [Additional Resources](#additional-resources)

## Overview

Audit logs in Kubernetes record the activities generated by users, applications interacting with the Kubernetes API, and the control plane itself. They help answer questions like:

- What happened?
- When did it happen?
- Who initiated it?
- On what did it happen?
- Where was it observed?
- From where was it initiated?
- To where was it going?

Audit records are generated by the `kube-apiserver` component. Each request, at various stages of its execution, produces an audit event processed according to a defined policy and written to a backend. The policy determines what's recorded, and the backends persist the records. Current backend implementations include log files and webhooks.

## Audit Policy Configuration

An audit policy defines the rules about what events are recorded and what data they include. Here's an example of an audit policy manifest:

```yaml
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: Metadata
  verbs: ["create", "update", "patch", "delete"]
  resources:
  - group: ""
    resources: ["pods", "services", "configmaps"]
  - group: "apps"
    resources: ["deployments", "statefulsets"]

In this policy:

    The level field specifies the amount of data to be logged. Levels include None, Metadata, Request, and RequestResponse.
    The verbs field specifies the Kubernetes API verbs (operations) to audit.
    The resources field specifies the resources and API groups to audit.

For a detailed explanation of policy fields, refer to the Kube-apiserver Audit Configuration.
Enabling Audit Logging

To enable audit logging:

    Create the Audit Policy File: Save your audit policy (e.g., the example above) to a file, such as audit-policy.yaml.

    Configure the Kube-apiserver: Modify the kube-apiserver configuration to include the following flags:

    --audit-policy-file=/etc/kubernetes/audit-policy.yaml
    --audit-log-path=/var/log/kubernetes/audit.log

        --audit-policy-file specifies the path to the audit policy file.
        --audit-log-path specifies the path where audit logs will be written.

    Restart the Kube-apiserver: After modifying the configuration, restart the kube-apiserver to apply the changes.

Audit Backends

Kubernetes supports different backends for storing audit logs:

    Log Backend: Writes audit events to a log file on disk. Configure it using flags like --audit-log-path and --audit-log-maxage.

    Webhook Backend: Sends audit events to an external API server. Configure it using flags like --audit-webhook-config-file and --audit-webhook-mode.

Audit Annotations

Audit annotations provide additional context to audit events. For example:

    k8s.io/deprecated: Indicates if a request used a deprecated API version.
    k8s.io/removed-release: Specifies the release in which a deprecated API version is targeted for removal.

For more details, refer to the Audit Annotations documentation.
