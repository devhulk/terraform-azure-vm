
output "id" {

    value = azurerm_windows_virtual_machine.example.id

}

output "identity" {

    value = azurerm_windows_virtual_machine.example.identity

}

output "private_ip_address" {
  
    value = azurerm_windows_virtual_machine.example.private_ip_address

}

output "public_ip_address" {

    value = azurerm_windows_virtual_machine.example.public_ip_address
  
}

output "virtual_machine_id" {

    value = azurerm_windows_virtual_machine.example.virtual_machine_id
  
}