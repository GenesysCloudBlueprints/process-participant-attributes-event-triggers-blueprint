resource "local_file" "create_secureflow" {
    depends_on= [
      module.saveUserData_lambda_data_integration,
      module.saveUserData_lambda_data_action,
      module.paymentId_generator_lambda_data_integration,
      module.paymentID_lambda_data_action,
    ]
    content     = templatefile("architect-flow-templates/EventOrchestrator_Secure_Flow.tftpl", {dataAction = "${var.environment}-${var.generatePaymentId_prefix}"})
    filename = "architect-flows/EventOrchestrator_Secure_Flow.yaml"
}

resource "genesyscloud_flow" "event_orchestrator_secureflow" {
  depends_on = [
    local_file.create_secureflow
  ]

  filepath = "./architect-flows/EventOrchestrator_Secure_Flow.yaml"
}

resource "genesyscloud_flow" "event_orchestrator_inboundcall" {
  depends_on = [
    genesyscloud_flow.event_orchestrator_secureflow
  ]

  filepath = "./architect-flows/EventOrchestrator_Flow.yaml.yaml"
}

resource "local_file" "create_workflow" {
    depends_on= [
      genesyscloud_flow.event_orchestrator_inboundcall
    ]
    content     = templatefile("architect-flow-templates/EventOrchestrator_Workflow.tftpl", {dataAction = "${var.environment}-${var.saveData_prefix}"})
    filename = "architect-flows/EventOrchestrator_Workflow.yaml"
}

resource "genesyscloud_flow" "event_orchestrator_workflow" {
  depends_on = [
    local_file.create_workflow
  ]

  filepath = "./architect-flows/EventOrchestrator_Workflow.yaml"
}