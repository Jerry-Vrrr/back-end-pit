class FormNotifierMailer < ApplicationMailer
  require 'open-uri'


  def new_form_submission_email(form_entry)
    @form_entry = form_entry
    attachments["Certificate_of_Completion.pdf"] = {
      mime_type: 'application/pdf',
      content: generate_certificate_pdf
    }
    mail(
      from: 'wakeywakeyapp@outlook.com',
      to: @form_entry.email,
      subject: "Congratulations on Completing Apricot SEO Bootcamp!"
    ) do |format|
      format.html { render html: certificate_email_template.html_safe }
    end
  end

  private

  def generate_certificate_pdf
    pdf = Prawn::Document.new(page_size: 'A4', page_layout: :landscape) # Adjusting the page size and layout
    logo_url = "https://www.apricotlaw.com/wp-content/uploads/2023/11/ApricotLaw-Logo-3c.png"
    
    # Use URI.open to handle opening the remote image URL
    pdf.image URI.open(logo_url), width: 100, position: :center
    pdf.move_down 20
    pdf.text "Certificate of Completion", size: 30, style: :bold, align: :center
    pdf.move_down 20
    pdf.text "This certificate is proudly presented to:", align: :center
  
    # Use formatted_text to change only the name's color
    pdf.formatted_text [
      { text: "#{@form_entry.name}", size: 24, color: 'FF7054', style: :bold, align: :center }
    ], align: :center
    
    pdf.move_down 20
    pdf.text "For successfully completing Apricot's SEO Bootcamp", align: :center
    pdf.move_down 30
    pdf.text "Date: #{Time.now.strftime('%B %d, %Y')}", align: :center
    pdf.render
  end
  
  

  def certificate_email_template
    <<-HTML
    <!DOCTYPE html>
    <html>
      <body>
        <div style="width: 100%; max-width: 600px; margin: 0 auto; background-color: #f4f4f4; font-family: Arial, sans-serif; color: #333; padding: 20px; border-radius: 8px; border: 1px solid #ddd;">
          <div style="text-align: center; padding-bottom: 20px;">
            <img
              src="https://www.apricotlaw.com/wp-content/uploads/2023/11/ApricotLaw-Logo-3c.png"
              alt="Apricot Law Logo"
              style="width: 200px; margin-bottom: 10px;"
            />
            <h1 style="font-size: 24px; color: #FF7054;">Congratulations, #{@form_entry.name}!</h1>
          </div>
          <div style="line-height: 1.6;">
            <p>We're excited to inform you that you have successfully completed Apricot's SEO Bootcamp! This is a significant achievement, and we commend you for your dedication and hard work.</p>
            <p>As a token of our appreciation, we have prepared a Certificate of Completion for you. Click the button below to download your certificate.</p>
            <a href="https://example.com/certificate_download" style="display: inline-block; padding: 10px 20px; background-color: #ff7054; color: white; text-decoration: none; border-radius: 5px; margin-top: 20px;">Download Your Certificate</a>
          </div>
          <div style="text-align: center; padding-top: 10px; font-size: 12px; color: #777;">
            <p>Thank you for choosing Apricot's SEO Bootcamp. Keep learning and growing!</p>
          </div>
        </div>
      </body>
    </html>
    HTML
  end
end
