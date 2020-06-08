require 'httparty'
require 'json'
require 'date'

file = File.read('api_key.json')

data_hash = JSON.parse(file)

puts 'Ingrese cliente:'
client_dni = gets.chomp!
while client_dni == ''
  puts 'Ingrese cliente:'
  client_dni = gets.chomp!
end

puts 'Ingrese debtor dni:'
debtor_dni = gets.chomp!
while debtor_dni == ''
  puts 'Ingrese debtor dni:'
  debtor_dni = gets.chomp!
end

puts 'Ingrese documentos:'
document_amount = gets.chomp!
while document_amount == ''
  puts 'Ingrese documentos:'
  document_amount = gets.chomp!
end

puts 'Ingrese folio:'
folio = gets.chomp!
while folio == ''
  puts 'Ingrese folio:'
  folio = gets.chomp!
end

puts 'Ingrese fecha de expiracion:(formato yyyy-mm-dd)'
expiration_date = gets.chomp!
while expiration_date == ''
  puts 'Ingrese fecha de expiracion:(formato yyyy-mm-dd)'
  expiration_date = gets.chomp!
end

url_api = "https://chita.cl/api/v1/pricing/simple_quote?client_dni=#{client_dni}&debtor_dni=#{debtor_dni}&document_amount=#{document_amount}&folio=#{folio}&expiration_date=#{expiration_date}%27"

def send_request(url, client_id)
  HTTParty.get(url, headers: client_id) 
end

data = send_request(url_api, data_hash)

document_rate = data['document_rate']
commission = data['commission']
advance_percent = data['advance_percent']

current = Time.now
date1 = Date.parse(expiration_date)
date2 = Date.parse(current.strftime('%Y-%m-%d'))

dedline_days = ((date1 - date2).to_f + 1)

# puts "prueba de api document_rate:  #{document_rate} | commission: #{commission} |  advance_percent: #{advance_percent}"
# puts "dias de plazo : #{dedline_days}"
# puts "monto factura : #{document_amount}, porcentaje de anticipo: #{advance_percent}, tasa de negocio: #{document_rate}, dia limite: #{dedline_days}"

costo_financiamiento = document_amount.to_f * (advance_percent.to_f / 100) * ((document_rate.to_f / 100) / 30 * dedline_days.to_f)
giro_recibir = (document_amount.to_f * (advance_percent.to_f / 100)) - costo_financiamiento - commission
excedentes = (document_amount.to_f - (document_amount.to_f * (advance_percent.to_f / 100)))

puts "costo de finianciamiento : $#{costo_financiamiento.round}"
puts "giro a recibir : $#{giro_recibir.round}"
puts "Excedentes : $#{excedentes.round}"