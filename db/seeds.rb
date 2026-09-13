admin = User.find_or_create_by!(email: "admin@abadacapoeira.com.br") do |user|
  user.name = "Admin Abadá"
  user.password = "senha123456"
  user.role = :admin
end
admin.update!(role: :admin)

student = User.find_or_create_by!(email: "aluno@abadacapoeira.com.br") do |user|
  user.name = "Aluno Teste"
  user.phone = "(11) 99999-0000"
  user.password = "senha123456"
  user.role = :student
end

points_data = [
  {
    teacher_name: "Mestre João Silva",
    phone: "(11) 98888-1111",
    street: "Avenida Paulista",
    number: "1000",
    neighborhood: "Bela Vista",
    city: "São Paulo",
    state: "SP",
    zip_code: "01310-100",
    details: "Aulas de terça e quinta, 19h às 21h."
  },
  {
    teacher_name: "Professora Ana Costa",
    phone: "(21) 97777-2222",
    street: "Avenida Atlântica",
    number: "500",
    neighborhood: "Copacabana",
    city: "Rio de Janeiro",
    state: "RJ",
    zip_code: "22010-000",
    details: "Aulas de segunda, quarta e sexta, 18h."
  },
  {
    teacher_name: "Professor Carlos Souza",
    phone: "(31) 96666-3333",
    street: "Avenida Afonso Pena",
    number: "1500",
    neighborhood: "Centro",
    city: "Belo Horizonte",
    state: "MG",
    zip_code: "30130-921",
    details: "Aulas aos sábados pela manhã."
  }
]

points_data.each do |attrs|
  Point.find_or_create_by!(teacher_name: attrs[:teacher_name]) { |point| point.assign_attributes(attrs) }
end

event = Event.find_or_create_by!(title: "Jogos da Capital 2026") do |e|
  e.status = "published"
  e.starts_at = 3.months.from_now.change(hour: 9)
  e.ends_at = 3.months.from_now.change(hour: 18)
  e.registration_deadline = 2.months.from_now.to_date
  e.description = "Evento anual reunindo todos os núcleos da Abadá Capoeira para uma roda especial, com bateria, jogos e homenagens. Inscrição via PIX: chave contato@abadacapoeira.com.br."
end

if event.event_fields.empty?
  event.event_fields.create!(label: "Corda", field_type: :choice, required: true, position: 1,
    options: [ "Crua", "Amarela", "Amarela e Azul", "Azul", "Verde" ])
  event.event_fields.create!(label: "Idade", field_type: :number, required: true, position: 2)
  event.event_fields.create!(label: "Nome do professor", field_type: :text, required: true, position: 3)
  event.event_fields.create!(label: "Tamanho da camiseta", field_type: :choice, required: false, position: 4,
    options: [ "P", "M", "G", "GG" ])
end

puts "Seed concluída."
puts "Admin: admin@abadacapoeira.com.br / senha123456"
puts "Aluno: aluno@abadacapoeira.com.br / senha123456"
