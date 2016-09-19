database = {}

order_dates = []
ticket_dates = []
models = []

types = [
  'iPhone 7'
  'iPhone 7 Plus'
  'iPhone 6s'
  'iPhone 6s Plus'
]
colors = [
  {
    text: 'Diamantschwarz'
    background: '#000000'
    border: '#aaaaaa'
  }
  {
    text: 'Schwarz'
    background: '#2E3034'
    border: '#aaaaaa'
  }
  {
    text: 'Silber'
    background: '#D0D0D4'
    border: '#aaaaaa'
  }
  {
    text: 'Gold'
    background: '#D4BBA3'
    border: '#aaaaaa'
  }
  {
    text: 'Roségold'
    background: '#D0A8A0'
    border: '#aaaaaa'
  }
  {
    text: 'Space Grau'
    background: '#2E3034'
    border: '#aaaaaa'
  }
]
storages = [
  {
    text: '32 GB'
    short_text: '32'
  }
  {
    text: '128 GB'
    short_text: '128'
  }
  {
    text: '256 GB'
    short_text: '256'
  }
]
devices =
  '99924989': #iPhone 6s 32 GB Space Grau
    type: 3
    storage: 1
    color: 6
  '99924991': #iPhone 6s 32 GB Gold
    type: 3
    storage: 1
    color: 4
  '99925024': #iPhone 6s 32 GB Roségold
    type: 3
    storage: 1
    color: 5
  '99925509': #iPhone 6s Plus 32 GB Space Grau
    type: 4
    storage: 1
    color: 6
  '99925516': #iPhone 6s Plus 32 GB Gold
    type: 4
    storage: 1
    color: 4
  '99925521': #iPhone 6s Plus 32 GB Silber
    type: 4
    storage: 1
    color: 3
  '99924988': #iPhone 6s 32 GB Silber
    type: 3
    storage: 1
    color: 3
  '99925511': #iPhone 6s Plus 32 GB Roségold
    type: 4
    storage: 1
    color: 5
  '99924964':
    type: 1
    storage: 1
    color: 4
  '99924969':
    type: 1
    storage: 1
    color: 5
  '99924966':
    type: 1
    storage: 1
    color: 3
  '99924982':
    type: 1
    storage: 1
    color: 2
  '99924986':
    type: 1
    storage: 2
    color: 1
  '99924980':
    type: 1
    storage: 2
    color: 4
  '99924971':
    type: 1
    storage: 2
    color: 5
  '99924967':
    type: 1
    storage: 2
    color: 3
  '99924984':
    type: 1
    storage: 2
    color: 2
  '99924987':
    type: 1
    storage: 3
    color: 1
  '99924965':
    type: 1
    storage: 3
    color: 4
  '99924985':
    type: 1
    storage: 3
    color: 5
  '99924981':
    type: 1
    storage: 3
    color: 3
  '99924968':
    type: 1
    storage: 3
    color: 2
  '99924972':
    type: 2
    storage: 1
    color: 4
  '99924994':
    type: 2
    storage: 1
    color: 5
  '99925000':
    type: 2
    storage: 1
    color: 3
  '99924976':
    type: 2
    storage: 1
    color: 2
  '99924977':
    type: 2
    storage: 2
    color: 1
  '99925011':
    type: 2
    storage: 2
    color: 4
  '99924963':
    type: 2
    storage: 2
    color: 5
  '99924990':
    type: 2
    storage: 2
    color: 3
  '99924974':
    type: 2
    storage: 2
    color: 2
  '99924979':
    type: 2
    storage: 3
    color: 1
  '99924973':
    type: 2
    storage: 3
    color: 4
  '99924962':
    type: 2
    storage: 3
    color: 5
  '99924975':
    type: 2
    storage: 3
    color: 3
  '99924993':
    type: 2
    storage: 3
    color: 2

model_type = (model)->
  types[devices[model].type-1]

model_storage = (model)->
  storages[devices[model].storage-1].text

stringify_model = (model)->
  type = model_type(model)
  color = colors[devices[model].color-1]
  storage = storages[devices[model].storage-1]
  "#{storage.text}"

background_color = (model)->
  color = colors[devices[model].color-1]
  color.background

border_color = (model)->
  color = colors[devices[model].color-1]
  color.border

model_sorter = (x, y) ->
  model_x = devices[x]
  model_y = devices[y]

  type_diff = model_x.type - (model_y.type)
  return type_diff unless type_diff == 0

  storage_diff = model_x.storage - (model_y.storage)
  return storage_diff unless storage_diff == 0

  color_diff = model_x.color - (model_y.color)
  return color_diff unless color_diff == 0

  return 0

pad = (num, size)->
    s = "000000000" + num
    s.substr(s.length-size)

Date::kalenderWoche = ->
  DonnerstagDat = new Date(@getTime() + (3 - ((@getDay() + 6) % 7)) * 86400000)
  KWJahr = DonnerstagDat.getFullYear()
  DonnerstagKW = new Date(new Date(KWJahr, 0, 4).getTime() + (3 - ((new Date(KWJahr, 0, 4).getDay() + 6) % 7)) * 86400000)
  KW = Math.floor(1.5 + (DonnerstagDat.getTime() - DonnerstagKW.getTime()) / 86400000 / 7)

nicer_date = (date_string)->
  date = new Date(date_string)
  if isNaN( date.getTime())
    date_string
  else
    "#{pad(date.getDate(), 2)}.#{pad(date.getMonth()+1,2)}"

print_header = ->
  $header = $("<tr><th>Premierenticket:</th><th colspan='#{models.length}'>Lieferung in Wochen:</th></tr>")
  $('table.show').append($header)

prepare_week_table = ->
  current_kalenderwoche = (new Date()).kalenderWoche()
  for ticket_date in ticket_dates
    $row = $("<tr><th>#{nicer_date(ticket_date)}</th></tr>")
    for model in models
      for order_date in order_dates
        shipping_in_weeks = "?"
        shipping_text = ""
        try
          shipping_text = database[ticket_date][order_date][model]
          shipping_in_weeks = parseInt(shipping_text.replace("KW","").replace(" ", "")) - current_kalenderwoche
        $row.append("<td class='specific-order-date order-date-#{order_date} #{(shipping_text || "no-info").replace(" ", "")}'>#{shipping_in_weeks}</td>")
    $('table.show').append($row)

print_footer = ->
  $footer_type = $("<tr class='model_type'><th></th></tr>")
  last_model_type = null
  for model in models
    if model_type(model) == last_model_type
      $cell = $footer_type.find("th:last-child")
      $cell.attr('colspan', parseInt($cell.attr('colspan')) + 1)
    else
      last_model_type = model_type(model)
      $footer_type.append($("<th colspan='1'>#{model_type(model)}</th>"))
  $('table.show').append($footer_type)

  $footer_storage = $("<tr class='model_storage'><th></th></tr>")
  last_model_storage = null
  for model in models
    if model_storage(model) == last_model_storage
      $cell = $footer_storage.find("th:last-child")
      $cell.attr('colspan', parseInt($cell.attr('colspan')) + 1)
    else
      last_model_storage = model_storage(model)
      $footer_storage.append($("<th colspan='1'>#{model_storage(model)}</th>"))
  $('table.show').append($footer_storage)

  $footer_color = $("<tr><th></th></tr>")
  for model in models
    $footer_color.append($("<th style='background-color:#{background_color(model)}; color:white'>&nbsp;</th>"))
  $('table.show').append($footer_color)

load_order_date_selector = ->
  for order_date in order_dates
    $(".order_date_selector").append($("<li><a data-order-date='#{order_date}' class='order_date' href='#'>#{nicer_date(order_date)}</a></li>"))
  $('.order_date').click (e)->
    e.preventDefault()
    order_date = $(@).data('order-date')
    $(".order_date_selector").find('li').removeClass('active')
    $(".order_date[data-order-date=#{order_date}]").closest('li').addClass('active')

    $(".specific-order-date").css("display", "none")
    $("td.order-date-#{order_date}").css("display", "table-cell")
  $(".order_date_selector").find('li:nth-child(2) a').trigger('click')

process_data = (data, no_ticket_date_value='')->
  for model, shipping_infos of data
    if devices[model]
      models.push(model) unless model in models
    else
      console.log "Device unknown: #{model}"
    for info in shipping_infos
      info.ticket_date = info.ticket_date || no_ticket_date_value
      ticket_dates.push(info.ticket_date) unless info.ticket_date in ticket_dates
      order_dates.push(info.order_date) unless info.order_date in order_dates
      database[info.ticket_date] ||= {}
      database[info.ticket_date][info.order_date] ||= {}

      database[info.ticket_date][info.order_date][model] = info.shipping_text

process_with_ticket = ->
  process_data(data_with_ticket.data)

process_without_ticket = ->
  process_data(data_without_ticket.data, 'Ohne Ticket')

process_magenta1 = ->
  process_data(data_magenta1.data, '<p style="color: silver; font-size: 10px; line-heigt: 1; padding: 0; margin: 0; font-weight: normal;">Magenta 1 Kunden[1]</p>')

jQuery ($)->
  #Build model
  process_with_ticket()
  process_without_ticket()
  process_magenta1()

  #Sort indizes
  order_dates = order_dates.sort()
  ticket_dates = ticket_dates.sort()
  models = models.sort(model_sorter)

  #View
  print_header()
  prepare_week_table()
  print_footer()
  load_order_date_selector()
