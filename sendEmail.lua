function sendEmail(messageBody, subject, emailAddress)
    emailAddress = emailAddress or 'avi.ziskind@gmail.com'
    --sys.execute(string.format('echo "%s" | mail -s "%s" "%s"', messageBody, subject, emailAddress))    
end
--cat test.txt | mail -s "Test" "avi.ziskind@gmail.com"