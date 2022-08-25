data "genesyscloud_flow" "IVR_id" {
  depends_on = [
    genesyscloud_flow.event_orchestrator_inboundcall
  ]
  name = "Main IVR"
}

resource "genesyscloud_telephony_providers_edges_did_pool" "mygcv_numbers" {
  start_phone_number = var.IVR_start_number              
  end_phone_number   = var.IVR_end_number
  description        = "GCV Numbers for inbound calls"
  comments           = "Additional comments"
  depends_on = [
    genesyscloud_flow.event_orchestrator_inboundcall
  ]
}

resource "genesyscloud_architect_ivr" "test-ivr" {
  name               = "Event Orchestration IVR"
  description        = "Main IVR of event orchestration setup"
  dnis               = [var.IVR_start_number,var.IVR_end_number]
  open_hours_flow_id = data.genesyscloud_flow.IVR_id.id
  depends_on         = [genesyscloud_telephony_providers_edges_did_pool.mygcv_numbers]
}