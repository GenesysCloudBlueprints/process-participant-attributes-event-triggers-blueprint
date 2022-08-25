data "genesyscloud_flow" "get_flow" {
  depends_on = [
    genesyscloud_flow.event_orchestrator_workflow
  ]
  name = "EventOrchestrator Flow"
}

resource "null_resource" "trigger" {
  depends_on = [
    genesyscloud_flow.event_orchestrator_workflow,
    data.genesyscloud_flow.get_flow
  ]

  provisioner "local-exec" {
    command = "python3 workflow_trigger/trigger.py ${data.genesyscloud_flow.get_flow.id}"
  }
}

