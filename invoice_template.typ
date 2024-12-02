#set text(font: "JetBrains Mono")

#let date = datetime(year: 2024, month: 12, day: 02)

#set text(fill: rgb(26, 54, 93))
#let invoice(company-info: (), client-info: (), items: ()) = {
  grid(columns: (1fr, auto), align(left)[
    = Invoice
    #date.display()
  ], align(right)[
    // Logo placeholder
  ])

  line(length: 100%, stroke: 3.0pt + rgb(26, 54, 93))
  v(2em)

  grid(columns: (1fr, 1fr), gutter: 2em, [
    #set text(fill: rgb(45, 55, 72))
    *From*: #company-info.name \
    #company-info.address \
    #company-info.city \
    *BSB*: #company-info.bsb \
    *Account*: #company-info.account \
    *ABN*: #company-info.abn
  ], [
    #set text(fill: rgb(45, 55, 72))
    *Bill To:*
    #client-info.name \
    #client-info.address \
    #client-info.city
  ])

  v(2em)

  let headers = ("Description", "Hours", "Quantity", "GST", "Total")

block(
  width: 100%, radius: 4pt,
)[
  #table(
    columns: (1fr, auto, auto, auto, auto),
    inset: (x: 12pt, y: 16pt),
    gutter: 12pt,
    stroke: none,
    fill: (_, row) => if row == 0 { rgb(226, 232, 240) } else { rgb(247, 248, 249) },
    [#set text(fill: rgb(26, 54, 93)); *Description*],
    [#set text(fill: rgb(26, 54, 93)); *Hours*],
    [#set text(fill: rgb(26, 54, 93)); *Quantity*],
    [#set text(fill: rgb(26, 54, 93)); *GST*],
    [#set text(fill: rgb(26, 54, 93)); *Total*],
    ..items.map(item => {
      let itemTotal = "$" + str(item.hours * item.quantity)
      let itemQuantity = "$" + str(item.quantity)
      let itemGST = str(item.GST) + "%"
      (
        box(width: 100%)[#text(fill: rgb(45, 55, 72))[#item.description]],
        text(fill: rgb(45, 55, 72))[#align(right)[#str(item.hours)]],
        text(fill: rgb(45, 55, 72))[#align(right)[#itemQuantity]],
        text(fill: rgb(45, 55, 72))[#align(right)[#itemGST]],
        text(fill: rgb(45, 55, 72))[#align(right)[#itemTotal]]
      )
    }).flatten()
  )
]
  let total = items.fold(0, (sum, item) => {
    let subtotal = item.hours * item.quantity
    let gst = subtotal * (item.GST / 100)
    sum + subtotal + gst
  })
  let fmtTotal = "$" + str(total)

  v(1em)
  align(right)[
    #block(fill: rgb(26, 54, 93), inset: (x: 24pt, y: 12pt), radius: 4pt)[
      #set text(fill: white)
      *Total: #fmtTotal*
    ]
  ]
}

#let doc = {
  invoice(
    company-info: (
      name: "[Your Company]", 
      address: "[Address]", 
      city: "[City Details]", 
      bsb: "[BSB]", 
      account: "[Account]",
      abn: "[ABN]"
    ), 
    client-info: (
      name: "[Client Name]", 
      address: "[Client Address]", 
      city: "[Client City]",
    ), 
    items: ((
      description: "[Service Description]", 
      hours: 0, 
      quantity: 0, 
      GST: 0
    ),),
  )
}

#doc
