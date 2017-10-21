class EmailsController < ApplicationController
  def new
    @email = Email.new
  end

  def index
  end

  def show
  end

  def create
    # fetch newly created email
    email = params["email"]

    # convert information in datetime_select form to Ruby date:
    # https://stackoverflow.com/questions/5073756/where-is-the-
    # rails-method-that-converts-data-from-datetime-select-into-a-datet

    #puts email["created_at(2i)"]

    send_date = DateTime.new(email["created_at(1i)"].to_i,
                        email["created_at(2i)"].to_i,
                        email["created_at(3i)"].to_i,
                        email["created_at(4i)"].to_i,
                        email["created_at(5i)"].to_i)

    # Run bin/delayed_job start to process all jobs

    # delayed job
    User.all.each do |user|
      GeneralMailer.reminder_email(user).deliver_later
    end

    # send at scheduled date time by admin
    User.all.each do |user|
      GeneralMailer.delay(queue:"reminder", run_at: send_date).reminder_email(user)
    end
  end
end