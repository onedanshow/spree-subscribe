Spree::OrderMailer.class_eval do

  def reorder_email order
    puts 'Sending reminder subscription'
    subject = "#{Spree::Config[:site_name]} #{t('order_mailer.reorder_email.subject', order_number: order.number)}"
    body = t('order_mailer.reorder_email.body', order_number: order.number)
    mail(to:      order.email,
         from:    from_address,
         subject: subject,
         body:    body)
  end
end
