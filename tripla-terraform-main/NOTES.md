Terraform improvements:
- Refactored for multi-environment usage
- Migrated to eks_managed_node_groups
- Removed hardcoded values
- Improved S3 security (private ACL)
- Added reusable tagging strategy

Helm fixes:
- Added missing deployment selectors
- Fixed frontend label mismatch
- Added container ports
- Converted static YAML into Helm templates
- Integrated values.yaml for configurability

- Ai I have used for referencing things related to EKS and few errors fixes during the deployment on minikube cluster.
