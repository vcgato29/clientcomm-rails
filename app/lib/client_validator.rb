class ClientValidator < ActiveModel::Validator
  def validate(record)
    client = Client.find_by_phone_number(record.phone_number)
    if client
      record.errors.add(:phone_number, :taken)
    end

  end
end

  # taken by user
  # taken in department
  # taken outside department

  # def phone_number_is_unused
  #   client = Client.find_by_phone_number(phone_number)
  #   if client
  #     if client.user != user
  #       errors.add(:phone_number, :external_user_taken, user_full_name: client.user.full_name)
  #     else
  #       if client.active
  #         errors.add(:phone_number, :taken)
  #       else
  #         errors.add(:phone_number, :inactive_taken)
  #       end
  #     end
  #   end
  # end

  # before_validation :normalize_phone_number, if: :phone_number_changed?
  # validate :service_accepts_phone_number, if: :phone_number_changed?

  # validate :phone_number_is_unused, if: :phone_number_changed?

  # def phone_number_is_unused
  #   client = Client.find_by_phone_number(phone_number)
  #   if client
  #     if client.user != user
  #       errors.add(:phone_number, :external_user_taken, user_full_name: client.user.full_name)
  #     else
  #       if client.active
  #         errors.add(:phone_number, :taken)
  #       else
  #         errors.add(:phone_number, :inactive_taken)
  #       end
  #     end
  #   end
  # end

  # def normalize_phone_number
  #   return unless self.phone_number

  #   self.phone_number = SMSService.instance.number_lookup(phone_number: self.phone_number)
  # rescue SMSService::NumberNotFound
  #   @bad_number = true
  # end

  # def service_accepts_phone_number
  #   errors.add(:phone_number, :invalid) if @bad_number
  # end

