require 'letter_opener/delivery_method'

module LetterOpenerWeb
  class DeliveryMethod < LetterOpener::DeliveryMethod
    def deliver!(mail)
      begin
        if ('EnvironmentUtils'.constantize rescue nil)
          EnvironmentUtils.system_notification(mail.from.first.to_s || 'No Sender', mail.subject.to_s || 'No Subject')
        end
      rescue => error
        if ('LoggingUtils'.constantize rescue nil)
          LoggingUtils.write_to_log(error)
        end
      end
      location = File.join(settings[:location], "#{Time.now.to_i}_#{Digest::SHA1.hexdigest(mail.encoded)[0..6]}")
      messages = LetterOpener::Message.rendered_messages(location, mail)
    end
  end
end
