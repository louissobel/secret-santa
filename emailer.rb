require 'mail'
require 'colorize'

# sourcefile should be a bunch of lines with
# {giver}SEPARATOR{receiver}
#
# Each giver or receiver should be pipe separated:
#   name|email
#
# To __actually__ send the emails, --send-for-real should be passed

sourcefile = ARGV[0]
SEPARATOR = "\t"

confirm = ARGV[1]
sendmails = (confirm == '--send-for-real')

# This should be a gmail credentials
GMAIL_ADDRESS = "foobar@gmail.com"
GMAIL_PASSWORD = "dsfksdjhfksdjhfdks"

# And this your name, for the email
FirstNameOfPersonSendingEmail = "Elf"

if sendmails
  puts "OK ACTUALLY SENDING EMAILS!!".red
  puts "sleeping for 5 seconds to give you a chance to abort...".blue
else
  puts "Pass arg '--send-for-real' to actually send emails".yellow
end

10.times do |i|
  case i
  when 0, 9
    puts (['x'] * 11).join(' ').red
  when 1
    puts (['x'] * 5).join(' ').red + ' * '.yellow.blink + (['x'] * 5).join(' ').red
  when 2...6
    puts (['x'] * (6 - i)).join(' ').red + ' ' + (['x'] * ((i - 1)*2 + 1)).join(' ').green + ' ' + (['x'] * (6 - i)).join(' ').red
  when 6...9
    puts (['x'] * 4).join(' ').red + ' ' + ([' '] * 3).join(' ').on_green + ' ' + (['x'] * 4).join(' ').red
  end
    
  sleep 0.5

end


emails = []

File.readlines(sourcefile).each do |line|
  line.chomp!
  unpacked = line.split(SEPARATOR).flat_map{ |pe| pe.split('|') }
  giver_name, giver_email, receiver_name, receiver_email = unpacked
  emails << {
    name: giver_name,
    email: giver_email,
    recipient: receiver_name
  }
end


######## now the email section

sentFrom = GMAIL_ADDRESS
password = GMAIL_PASSWORD
smtpserver = 'smtp.gmail.com'
smtpport = 587

SantaMessage = <<EOS
Hi %s, happy holidays!

Your assignment for secret santa is

%s

Have Fun! The exchange will sometime after thanksgiving.

- Robot#{FirstNameOfPersonSendingEmail}

Also, don't reply to this email, unless you want Human#{FirstNameOfPersonSendingEmail} to know who you have.
EOS

SantaSubject = 'Your Secret Santa Assignment!'

def secret_santa_email(name, assignment)
  SantaMessage % [name, assignment]
end


emails.each do |email|
  message = secret_santa_email(
    email[:name],
    email[:recipient]
  )

  mail = Mail.new do
    from sentFrom
    to email[:email]
    subject SantaSubject
    body message
  end

  mail.delivery_method :smtp, {
    address: smtpserver,
    port: 587,
    user_name: sentFrom,
    password: password,
    authentication: 'plain',
    enable_starttls_auto: true
  }

  puts "#{sentFrom} --> #{email[:email]}"

  if sendmails
    mail.deliver
  end

end   