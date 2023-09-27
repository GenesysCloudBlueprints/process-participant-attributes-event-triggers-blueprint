data "genesyscloud_flow" "get_flow" {
  depends_on = [
    genesyscloud_flow.event_orchestrator_workflow
  ]
  name = "EventOrchestrator Flow"
}

resource "genesyscloud_processautomation_trigger" "trigger" {
  depends_on = [
    genesyscloud_flow.event_orchestrator_workflow,
    data.genesyscloud_flow.get_flow
  ] 

  name       = "Call Disconnected Trigger"
  topic_name = "v2.detail.events.conversation.{id}.customer.end"
  enabled    = true

  target {
    id   = data.genesyscloud_flow.get_flow.id
    type = "Workflow"
  }
  
  match_criteria = jsonencode([
        {
            "jsonPath": "mediaType",
            "operator": "Equal",
            "value": "VOICE"
        }
    ])

  event_ttl_seconds = 60
} 
