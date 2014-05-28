$ ->
  $('[href="#amountOwed"]').click()

  Morris.Bar {
    element: 'divAmountOwed'
    data: dashboard.debts
    xkey: 'amount_owed_to_name'
    ykeys: ['amount_owed']
    labels: ['You owe']
    barRatio: 0.4
    xLabelAngle: 0
    hideHover: 'auto'
  }

  Morris.Bar {
    element: 'divAmountDue'
    data: dashboard.incoming
    xkey: 'from'
    ykeys: ['amount']
    labels: ['Owes you']
    hideHover: 'auto'
  }

  Morris.Area {
    element: 'divProportionalAmountPaid'
    data: dashboard.payments
    xkey: 'activity'
    parseTime: false
    behaveLikeLine: true
    ykeys: ['amount_paid', 'total_amount']
    labels: ['Amount You Paid', 'Total Amount']
    hideHover: 'auto'
  }
  
  $('[href="#dashboard"]').click();