local Email = require("Computer/Email");

local users = ModData.getOrCreate("EmailServiceUsers");
local mails = ModData.getOrCreate("EmailServiceMails");

local EmailService = {};

function EmailService.initialize()
    ModData.remove("EmailServiceUsers");
    ModData.remove("EmailServiceMails");
    users = ModData.getOrCreate("EmailServiceUsers");
    mails = ModData.getOrCreate("EmailServiceMails");
    mails.index = mails.index or 1;
end

function EmailService.userExist(username)
    return users[username]
end

function EmailService.createUser(username)
    if EmailService.userExist(username) then
        print("MailService user '" .. username .. "' already exist, cannot create!");
    else
        users[username] = {
            sent = {},
            received = {},
            read = {},
        };
        print("MailService user '" .. username .. "' created!");
    end
end

function EmailService.getEmailById(emailId)
    if mails[emailId] then
        return mails[emailId];
    end
end

function EmailService.sendMail(fromUsername, toUsername, title, message)
    if EmailService.userExist(fromUsername) then
        if EmailService.userExist(toUsername) then
            local email = Email:new({
                id = "mail_" .. mails.index,
                from = fromUsername,
                to = toUsername,
                title = title,
                message = message,
                datetime = {
                    year = getGameTime():getYear(),
                    month = getGameTime():getMonth(),
                    day = getGameTime():getDay(),
                    hour = getGameTime():getHour(),
                    minute = getGameTime():getMinutes(),
                },
            });

            if email:isValid() then
                mails[email.id] = email;
                mails.index = mails.index + 1;
                users[fromUsername].sent[email.id] = 1;
                users[toUsername].received[email.id] = 1;
                print("MailService user '" .. fromUsername .. "' sent email id '" .. tostring(email.id) .. "' to '" .. toUsername .. "'!");
            else
                print("MailService user '" .. fromUsername .. "' trying to send an invalid email!");
            end

        else
            print("MailService user '" .. toUsername .. "' doesn't exist, cannot receive email!");
        end
    else
        print("MailService user '" .. fromUsername .. "' doesn't exist, cannot send email!");
    end
end

function EmailService.readEmail(username, emailId)
    if EmailService.userExist(username) then
        if users[username].sent[emailId] or users[username].received[emailId] then
            local email = EmailService.getEmailById(emailId);
            if email then
                print("MailService email id '" .. email.id .. "'");
                print("From: " .. email.from);
                print("To: " .. email.to);
                print("Title: " .. email.title);
                print("Message: " .. email.message);
                print("Date: " .. email:getStringDateTime());
                users[username].read[email.id] = 1;
            else
                print("MailService user '" .. username .. "' trying to read email id '" .. emailId .. "', but email doesn't exist!");
            end
        else
            print("MailService user '" .. username .. "' cannot read email id '" .. emailId .. "'!");
        end
    else
        print("MailService user '" .. username .. "' doesn't exist, cannot read email!");
    end
end

function EmailService.deleteEmail(username, emailId)
    if EmailService.userExist(username) then
        if mails[emailId] then
            local email = Email:new(mails[emailId]);
            if email.from == username then
                users[username].sent[emailId] = nil;
            end
            if email.to == username then
                users[username].received[emailId] = nil;
                users[username].read[emailId] = nil;
            end
            if not users[email.from].sent[emailId] and not users[email.from].received[emailId] then
                mails[emailId] = nil;
                print("MailService email id '" .. emailId .. "' has been deleted completely!");
            end
        else
            print("MailService user '" .. username .. "' cannot delete email id '" .. emailId .. " cause it doesn't exist!");
        end
    else
        print("MailService user '" .. username .. "' doesn't exist, cannot delete email!");
    end
end

EmailService.initialize();

return EmailService;