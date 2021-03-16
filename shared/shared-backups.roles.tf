resource "google_organization_iam_custom_role" "shared-backups-test-role-svc-check-snapshots" {
  role_id     = "shared.backups.test.role.svc.check.snapshots"
  org_id      = var.organization_id
  title       = "shared-backups-test-role-svc-check-snapshots"
  description = "Role / permissions to assign to service account for automatically setting up disk snapshots. (test)"
  permissions = [
    "compute.disks.list",
    "compute.snapshots.list",
    "compute.instances.list",
    "compute.regions.list",
    "compute.zones.list",
    "compute.disks.addResourcePolicies",
    "compute.resourcePolicies.create",
    "compute.resourcePolicies.get",
    "compute.resourcePolicies.list",
    "compute.resourcePolicies.use",
    "resourcemanager.organizations.get",
    "resourcemanager.folders.get",
    "resourcemanager.folders.list",
    "resourcemanager.projects.get",
    "resourcemanager.projects.list",
    "storage.objects.create"
  ]
}
